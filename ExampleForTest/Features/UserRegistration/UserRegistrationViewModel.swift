
import Foundation
import Combine

enum ValidationError: Error, LocalizedError, Equatable {
    case usernameTooShort(min: Int)
    case usernameInvalidCharacters
    case emailInvalid
    case passwordTooShort(min: Int)
    case passwordMissingUppercase
    case passwordMissingDigit
    case passwordsNotMatching

    var errorDescription: String? {
        switch self {
        case .usernameTooShort(let min):
            return "사용자 이름은 최소 \(min)자 이상이어야 합니다."
        case .usernameInvalidCharacters:
            return "사용자 이름은 영문자와 숫자만 사용할 수 있습니다."
        case .emailInvalid:
            return "유효하지 않은 이메일 형식입니다."
        case .passwordTooShort(let min):
            return "비밀번호는 최소 \(min)자 이상이어야 합니다."
        case .passwordMissingUppercase:
            return "비밀번호는 대문자를 하나 이상 포함해야 합니다."
        case .passwordMissingDigit:
            return "비밀번호는 숫자를 하나 이상 포함해야 합니다."
        case .passwordsNotMatching:
            return "비밀번호가 일치하지 않습니다."
        }
    }
}


class UserRegistrationViewModel: ObservableObject {
    // MARK: - Input Properties
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""

    // MARK: - Validation Properties
    @Published var usernameValidation: Result<Void, ValidationError>?
    @Published var emailValidation: Result<Void, ValidationError>?
    @Published var passwordValidation: Result<Void, ValidationError>?
    @Published var passwordConfirmationValidation: Result<Void, ValidationError>?
    
    @Published var isFormValid = false

    private var cancellables = Set<AnyCancellable>()

    private let minUsernameLength = 5
    private let minPasswordLength = 8

    init() {
        setupValidationBindings()
    }

    private func setupValidationBindings() {
        // Username Validation
        $username
            .debounce(for: 0.1, scheduler: DispatchQueue.global())
            .map { [weak self] username -> Result<Void, ValidationError>? in
                guard let self = self else { return nil }
                guard !username.isEmpty else { return nil }
                return self.validateUsername(username)
            }
            .receive(on: RunLoop.main)
            .assign(to: &$usernameValidation)

        // Email Validation
        $email
            .debounce(for: 0.1, scheduler: DispatchQueue.global())
            .map { [weak self] email -> Result<Void, ValidationError>? in
                guard !email.isEmpty else { return nil }
                return self?.validateEmail(email)
            }
            .receive(on: RunLoop.main)
            .assign(to: &$emailValidation)

        // Password Validation
        $password
            .debounce(for: 0.1, scheduler: DispatchQueue.global())
            .map { [weak self] password -> Result<Void, ValidationError>? in
                guard let self = self else { return nil }
                guard !password.isEmpty else { return nil }
                return self.validatePassword(password)
            }
            .receive(on: RunLoop.main)
            .assign(to: &$passwordValidation)

        // Password Confirmation Validation
        Publishers.CombineLatest($password, $confirmPassword)
            .debounce(for: 0.1, scheduler: DispatchQueue.global())
            .map { [weak self] password, confirm -> Result<Void, ValidationError>? in
                guard let self = self else { return nil }
                guard !confirm.isEmpty else { return nil }
                return self.validatePasswordConfirmation(password: password, confirmation: confirm)
            }
            .receive(on: RunLoop.main)
            .assign(to: &$passwordConfirmationValidation)
        
        // Form Validation
        Publishers.CombineLatest4($usernameValidation, $emailValidation, $passwordValidation, $passwordConfirmationValidation)
            .map { user, mail, pass, confirm -> Bool in
                guard case .success = user, case .success = mail, case .success = pass, case .success = confirm else {
                    return false
                }
                return true
            }
            .receive(on: RunLoop.main)
            .assign(to: &$isFormValid)
    }

    // MARK: - Validation Logic
    func validateUsername(_ username: String) -> Result<Void, ValidationError> {
        if username.count < minUsernameLength {
            return .failure(.usernameTooShort(min: minUsernameLength))
        }
        let allowedCharacters = CharacterSet.alphanumerics
        if username.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return .failure(.usernameInvalidCharacters)
        }
        return .success(())
    }

    func validateEmail(_ email: String) -> Result<Void, ValidationError> {
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        if !emailPredicate.evaluate(with: email) {
            return .failure(.emailInvalid)
        }
        return .success(())
    }

    func validatePassword(_ password: String) -> Result<Void, ValidationError> {
        if password.count < minPasswordLength {
            return .failure(.passwordTooShort(min: minPasswordLength))
        }
        if password.rangeOfCharacter(from: .uppercaseLetters) == nil {
            return .failure(.passwordMissingUppercase)
        }
        if password.rangeOfCharacter(from: .decimalDigits) == nil {
            return .failure(.passwordMissingDigit)
        }
        return .success(())
    }

    func validatePasswordConfirmation(password: String, confirmation: String) -> Result<Void, ValidationError> {
        if password != confirmation {
            return .failure(.passwordsNotMatching)
        }
        return .success(())
    }
}

extension Result where Success == Void {
    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
    var error: Failure? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}
