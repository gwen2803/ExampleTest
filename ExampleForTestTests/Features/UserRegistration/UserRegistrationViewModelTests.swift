
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
    
    func testInitialState_ValidationPropertiesShouldBeNil() {
        // then
        // XCTAssertNil: 값이 nil인지 확인합니다.
        XCTAssertNil(sut.usernameValidation, "초기 사용자 이름 검증 결과는 nil이어야 합니다.")
        XCTAssertNil(sut.emailValidation, "초기 이메일 검증 결과는 nil이어야 합니다.")
        XCTAssertNil(sut.passwordValidation, "초기 비밀번호 검증 결과는 nil이어야 합니다.")
        XCTAssertNil(sut.passwordConfirmationValidation, "초기 비밀번호 확인 검증 결과는 nil이어야 합니다.")
    }
}
