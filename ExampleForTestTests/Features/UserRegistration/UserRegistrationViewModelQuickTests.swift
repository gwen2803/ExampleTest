
import Quick
import Nimble
import Combine
@testable import ExampleForTest

// QuickSpec을 상속받아 테스트 클래스를 정의합니다.
class UserRegistrationViewModelQuickTests: QuickSpec {
    override class func spec() {
        var sut: UserRegistrationViewModel!
        
        beforeEach {
            sut = UserRegistrationViewModel()
        }
        
        afterEach {
            sut = nil
        }
        
        describe("UserRegistrationViewModel") {
            describe("username validation") {
                context("when the input is valid") {
                    it("succeeds") {
                        let result = sut.validateUsername("validuser")
                        expect(result.isSuccess).to(beTrue())
                    }
                }
                
                context("when the input is too short") {
                    it("fails with a specific error") {
                        let result = sut.validateUsername("four")
                        expect(result.error).to(equal(.usernameTooShort(min: 5)))
                    }
                }
                
                context("when the input has invalid characters") {
                    it("fails with a specific error") {
                        let result = sut.validateUsername("invalid!@#")
                        expect(result.error).to(equal(.usernameInvalidCharacters))
                        expect(result.error).notTo(equal(.usernameTooShort(min: 5)))
                    }
                }
            }
            
            describe("email validation") {
                context("when the input is valid") {
                    it("succeeds") {
                        let result = sut.validateEmail("test@example.com")
                        expect(result.isSuccess).to(beTrue())
                    }
                }
                
                context("when the input is invalid") {
                    it("fails for missing @") {
                        let result = sut.validateEmail("testexample.com")
                        expect(result.error).to(equal(.emailInvalid))
                    }
                    it("fails for missing domain") {
                        let result = sut.validateEmail("test@.com")
                        expect(result.error).to(equal(.emailInvalid))
                    }
                    it("fails for missing top-level domain") {
                        let result = sut.validateEmail("test@example")
                        expect(result.error).to(equal(.emailInvalid))
                    }
                }
            }
            
            describe("password validation") {
                context("when the input is valid") {
                    it("succeeds") {
                        let result = sut.validatePassword("Password123")
                        expect(result.isSuccess).to(beTrue())
                    }
                }
                
                context("when missing uppercase") {
                    it("fails with a specific error") {
                        let result = sut.validatePassword("password123")
                        expect(result.error).to(equal(.passwordMissingUppercase))
                    }
                }
                
                context("when the password is too short") {
                    it("fails with a specific error") {
                        let result = sut.validatePassword("short")
                        expect(result.error).to(equal(.passwordTooShort(min: 8)))
                    }
                }
                
                context("when the password is missing a digit") {
                    it("fails with a specific error") {
                        let result = sut.validatePassword("NoDigitsHere")
                        expect(result.error).to(equal(.passwordMissingDigit))
                    }
                }
            }
            
            describe("password confirmation") {
                context("when passwords match") {
                    it("succeeds") {
                        let result = sut.validatePasswordConfirmation(
                            password: "Password123",
                            confirmation: "Password123"
                        )
                        expect(result.isSuccess).to(beTrue())
                    }
                }
                
                context("when passwords do not match") {
                    it("fails with a specific error") {
                        let result = sut.validatePasswordConfirmation(
                            password: "Password123",
                            confirmation: "Password1234"
                        )
                        expect(result.error).to(equal(.passwordsNotMatching))
                    }
                }
            }
            
            describe("form validity") {
                context("when all inputs become valid") {
                    it("isFormValid becomes true") {
                        sut.username = "validusername"
                        sut.email = "test@example.com"
                        sut.password = "ValidPassword1"
                        sut.confirmPassword = "ValidPassword1"
                        
                        expect(sut.isFormValid).toEventually(beTrue(), timeout: .seconds(2))
                    }
                }
                
                context("when a valid form becomes invalid") {
                    it("isFormValid becomes false") {
                        sut.username = "validusername"
                        sut.email = "test@example.com"
                        sut.password = "ValidPassword1"
                        sut.confirmPassword = "ValidPassword1"
                        
                        expect(sut.isFormValid).toEventually(beTrue(), timeout: .seconds(2))
                        
                        sut.password = "invalid"
                        
                        expect(sut.isFormValid).toEventually(beFalse(), timeout: .seconds(2))
                    }
                }
                
                context("initial state") {
                    it("isFormValid is false") {
                        expect(sut.isFormValid).to(beFalse())
                    }
                }
                
                context("when form becomes valid, then invalid, then valid again") {
                    it("isFormValid transitions correctly") {
                        // 1. Start invalid
                        expect(sut.isFormValid).to(beFalse())
                        
                        // 2. Make valid
                        sut.username = "validusername"
                        sut.email = "test@example.com"
                        sut.password = "ValidPassword1"
                        sut.confirmPassword = "ValidPassword1"
                        expect(sut.isFormValid).toEventually(beTrue(), timeout: .seconds(2))
                        
                        // 3. Make invalid
                        sut.password = "invalid"
                        expect(sut.isFormValid).toEventually(beFalse(), timeout: .seconds(2))
                        
                        // 4. Make valid again
                        sut.password = "ValidPassword1"
                        expect(sut.isFormValid).toEventually(beTrue(), timeout: .seconds(2))
                    }
                }
            }
        }
    }
}
