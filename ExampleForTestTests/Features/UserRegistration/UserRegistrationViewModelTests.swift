import XCTest
import Combine
@testable import ExampleForTest

final class UserRegistrationViewModelTests: XCTestCase {

    var sut: UserRegistrationViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        executionTimeAllowance = 2.0 // 각 테스트의 타임아웃을 2초로 설정
        sut = UserRegistrationViewModel()
        cancellables = []
    }
   
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
   
    // MARK: - Username Validation Tests
   
    func testUsername_WhenInputIsValid_ShouldReturnSuccess() {
        // given
        let validUsername = "validuser"
   
        // when
        let result = sut.validateUsername(validUsername)
   
        // then
        XCTAssertTrue(result.isSuccess)
    }
   
    func testUsername_WhenTooShort_ShouldReturnFailure() throws {
        // given
        let shortUsername = "four"
   
        // when
        let result = sut.validateUsername(shortUsername)
   
        // then
        let error = try XCTUnwrap(result.error)
        XCTAssertEqual(error, .usernameTooShort(min: 5), "사용자 이름이 짧을 때 정확한 에러를 반환해야 합니다.")
    }
   
    func testUsername_WhenHasInvalidCharacters_ShouldReturnFailure() throws {
        // given
        let invalidUsername = "invalid!@#"
   
        // when
        let result = sut.validateUsername(invalidUsername)
   
        // then
        let error = try XCTUnwrap(result.error)
        XCTAssertEqual(error, .usernameInvalidCharacters)
        XCTAssertNotEqual(error, .usernameTooShort(min: 5))
    }

    // MARK: - Email Validation Tests (추가됨)

    func testEmail_WhenInputIsValid_ShouldReturnSuccess() {
        // given
        let validEmail = "test@example.com"
        // when
        let result = sut.validateEmail(validEmail)
        // then
        XCTAssertTrue(result.isSuccess)
    }

    func testEmail_WhenInvalidFormat_ShouldReturnFailure() throws {
        // given
        let invalidEmail = "testexample.com" // @ 없음
        // when
        let result = sut.validateEmail(invalidEmail)
        // then
        let error = try XCTUnwrap(result.error)
        XCTAssertEqual(error, .emailInvalid)
    }

    func testEmail_WhenMissingDomain_ShouldReturnFailure() throws {
        // given
        let invalidEmail = "test@" // 도메인 없음
        // when
        let result = sut.validateEmail(invalidEmail)
        // then
        let error = try XCTUnwrap(result.error)
        XCTAssertEqual(error, .emailInvalid)
    }

    // MARK: - Password Validation Tests

    func testPassword_WhenValid_ShouldReturnSuccess() {
        // given
        let validPassword = "Password123"

        // when
        let result = sut.validatePassword(validPassword)
  
        // then
        XCTAssertTrue(result.isSuccess)
    }
  
    func testPassword_WhenMissingUppercase_ShouldReturnFailure() throws {
        // given
        let noUppercase = "password123"
  
        // when
        let result = sut.validatePassword(noUppercase)
  
        // then
        let error = try XCTUnwrap(result.error)
        XCTAssertEqual(error, .passwordMissingUppercase)
    }
  
    func testPassword_WhenTooShort_ShouldReturnFailure() throws { // 추가됨
        // given
        let shortPassword = "short"
        // when
        let result = sut.validatePassword(shortPassword)
        // then
        let error = try XCTUnwrap(result.error)
        XCTAssertEqual(error, .passwordTooShort(min: 8))
    }
  
    func testPassword_WhenMissingDigit_ShouldReturnFailure() throws { // 추가됨
        // given
        let noDigit = "NoDigitsHere"
        // when
        let result = sut.validatePassword(noDigit)
        // then
        let error = try XCTUnwrap(result.error)
        XCTAssertEqual(error, .passwordMissingDigit)
    }
  
    // MARK: - Password Confirmation Tests (추가됨)
  
    func testPasswordConfirmation_WhenPasswordsMatch_ShouldReturnSuccess() {
        // given
        let password = "Password123"
        let confirmation = "Password123"
        // when
        let result = sut.validatePasswordConfirmation(
            password: password,
            confirmation: confirmation
        )
        // then
        XCTAssertTrue(result.isSuccess)
    }
  
    func testPasswordConfirmation_WhenPasswordsDoNotMatch_ShouldReturnFailure() throws {
        // given
        let password = "Password123"
        let confirmation = "Password1234"
        // when
        let result = sut.validatePasswordConfirmation(
            password: password,
            confirmation: confirmation
        )
        // then
        let error = try XCTUnwrap(result.error)
        XCTAssertEqual(error, .passwordsNotMatching)
    }
  
    // MARK: - Form Validity (Async) Tests
  
    func testFormValidity_WhenAllInputsAreValid_ShouldBeTrue() async {
        // given
  
        // when
        sut.username = "validusername"
        sut.email = "test@example.com"
        sut.password = "ValidPassword1"
        sut.confirmPassword = "ValidPassword1"
  
        // then
        // sut.$isFormValid publisher가 debounce 시간 때문에 여러 중간값(false)이 올 수 있으므로, true가 될 때까지 기다립니다.
        var finalState = false
        for await isValid in sut.$isFormValid.values {
            if isValid {
                finalState = true
                break
            }
        }
  
        XCTAssertTrue(finalState)
    }
  
    func testFormValidity_WhenAnInputBecomesInvalid_ShouldBeFalse() async {
        // given
        // 먼저 모든 값을 유효하게 설정
        sut.username = "validusername"
        sut.email = "test@example.com"
        sut.password = "ValidPassword1"
        sut.confirmPassword = "ValidPassword1"
  
        // sut.$isFormValid publisher가 debounce 시간 때문에 여러 중간값(false)이 올 수 있으므로, true가 될 때까지 기다립니다.
        for await isValid in sut.$isFormValid.values {
            if isValid { break }
        }
  
        // when
        // 비밀번호를 유효하지 않게 변경
        sut.password = "invalid"
  
        // then
        // isFormValid가 false로 바뀔 때까지 기다림
        var finalState = true
        for await isValid in sut.$isFormValid.values {
            if !isValid {
                finalState = false
                break
            }
        }
  
        XCTAssertFalse(finalState)
    }
  
    // MARK: - Form Validity Edge Cases (추가됨)
  
    func testFormValidity_InitialState_ShouldBeFalse() { // 추가됨
        // given (sut는 setUp에서 초기화됨)
        // when (초기 상태)
        // then
        XCTAssertFalse(sut.isFormValid, "폼의 초기 상태는 false여야 합니다.")
    }
  
    func testFormValidity_WhenTransitionsValidInvalidValid_ShouldBeCorrect() async { // 추가됨
        // given
        // sut는 setUp에서 초기화됨
  
        // 1. Make valid
        sut.username = "validusername"
        sut.email = "test@example.com"
        sut.password = "ValidPassword1"
        sut.confirmPassword = "ValidPassword1"
  
        // Wait for it to become valid
        for await isValid in sut.$isFormValid.values {
            if isValid { break }
        }
        XCTAssertTrue(sut.isFormValid, "첫 번째 유효 상태 전환 실패")
  
        // 2. Make invalid
        sut.password = "invalid"
  
        // Wait for it to become invalid
        for await isValid in sut.$isFormValid.values {
            if !isValid { break }
        }
        XCTAssertFalse(sut.isFormValid, "유효하지 않은 상태 전환 실패")
  
        // 3. Make valid again
        sut.password = "ValidPassword1"
  
        // Wait for it to become valid again
        for await isValid in sut.$isFormValid.values {
            if isValid { break }
        }
        XCTAssertTrue(sut.isFormValid, "두 번째 유효 상태 전환 실패")
    }
  
    // MARK: - Initial State Tests
  
    func testInitialState_ValidationPropertiesShouldBeNil() {
        // then
        // XCTAssertNil: 값이 nil인지 확인합니다.
        XCTAssertNil(sut.usernameValidation, "초기 사용자 이름 검증 결과는 nil이어야 합니다.")
        XCTAssertNil(sut.emailValidation, "초기 이메일 검증 결과는 nil이어야 합니다.")
        XCTAssertNil(sut.passwordValidation, "초기 비밀번호 검증 결과는 nil이어야 합니다.")
        XCTAssertNil(sut.passwordConfirmationValidation, "초기 비밀번호 확인 검증 결과는 nil이어야 합니다.")
    }
}
