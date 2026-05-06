import Foundation

/// Equivalent of Kotlin's AuthViewModel.
/// Uses @MainActor so @Published updates always happen on the main thread.
@MainActor
final class AuthViewModel: ObservableObject {

    @Published var loginState:    Resource<LoginResponse>?    = nil
    @Published var registerState: Resource<RegisterResponse>? = nil
    @Published var loggedUser:    UserDto?                    = nil

    private let repository = AuthRepository()

    // MARK: - Login

    func login(identifier: String, password: String) {
        loginState = .loading
        Task {
            let result = await repository.login(identifier: identifier, password: password)
            loginState = result
            if case .success(let response) = result {
                loggedUser = response.data?.user
            }
        }
    }

    // MARK: - Register

    func register(
        email: String,
        firstName: String,
        lastName: String,
        password: String,
        roleName: String,
        username: String
    ) {
        registerState = .loading
        Task {
            registerState = await repository.register(
                email: email, firstName: firstName, lastName: lastName,
                password: password, roleName: roleName, username: username
            )
        }
    }

    // MARK: - Logout

    func logout() {
        loggedUser    = nil
        loginState    = nil
        registerState = nil
    }

    func resetLoginState()    { loginState    = nil }
    func resetRegisterState() { registerState = nil }
}
