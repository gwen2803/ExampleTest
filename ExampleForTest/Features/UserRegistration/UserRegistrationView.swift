import SwiftUI

struct UserRegistrationView: View {
    @StateObject private var viewModel = UserRegistrationViewModel()
    @State private var showingSuccessAlert = false

    var body: some View {
        Form {
            Section(header: Text("사용자 정보")) {
                TextField("사용자 이름", text: $viewModel.username)
                    .autocapitalization(.none)
                ValidationMessageView(validationResult: viewModel.usernameValidation)

                TextField("이메일", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                ValidationMessageView(validationResult: viewModel.emailValidation)
            }

            Section(header: Text("비밀번호")) {
                SecureField("비밀번호", text: $viewModel.password)
                ValidationMessageView(validationResult: viewModel.passwordValidation)

                SecureField("비밀번호 확인", text: $viewModel.confirmPassword)
                ValidationMessageView(validationResult: viewModel.passwordConfirmationValidation)
            }
            
            Section {
                Button(action: {
                    self.showingSuccessAlert = true
                }) {
                    Text("등록하기")
                }
                .disabled(!viewModel.isFormValid)
            }
        }
        .navigationTitle("사용자 등록")
        .alert("등록 성공", isPresented: $showingSuccessAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("모든 유효성 검사를 통과했습니다.")
        }
    }
}

struct ValidationMessageView: View {
    let validationResult: Result<Void, ValidationError>?

    var body: some View {
        if case .failure(let error) = validationResult {
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}

#Preview {
    NavigationStack{
        UserRegistrationView()
    }
}