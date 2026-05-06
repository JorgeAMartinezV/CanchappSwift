import Foundation

@MainActor
final class AuthRepository {

    private let api = APIService.shared

    // MARK: - Login

    func login(identifier: String, password: String) async -> Resource<LoginResponse> {
        do {
            let (response, rawData) = try await api.login(identifier: identifier, password: password)
            if response.success {
                return .success(response)
            }
            return .error(extractErrorMessage(from: rawData, fallback: response.message ?? "Error al iniciar sesión"))
        } catch {
            return .error(networkErrorMessage(error))
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
    ) async -> Resource<RegisterResponse> {
        do {
            let (response, rawData) = try await api.register(
                email: email, firstName: firstName, lastName: lastName,
                password: password, roleName: roleName, username: username
            )
            if response.success {
                return .success(response)
            }
            return .error(extractErrorMessage(from: rawData, fallback: response.message ?? "Error al registrar"))
        } catch {
            return .error(networkErrorMessage(error))
        }
    }

    // MARK: - Error helpers

    private func networkErrorMessage(_ error: Error) -> String {
        if let urlError = error as? URLError,
           urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
            return "Sin conexión a internet"
        }
        return "Error inesperado: \(error.localizedDescription)"
    }

    private let fieldLabels: [String: String] = [
        "identifier": "Usuario/correo",
        "password":   "Contraseña",
        "email":      "Correo",
        "username":   "Usuario",
        "f_name":     "Nombre",
        "l_name":     "Apellido",
        "role_name":  "Tipo de cuenta"
    ]

    private func extractErrorMessage(from data: Data, fallback: String) -> String {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return fallback
        }
        let base: String
        if let errorObj = json["error"] as? [String: Any],
           let msg = errorObj["message"] as? String {
            base = msg
        } else if let msg = json["message"] as? String {
            base = msg
        } else {
            base = fallback
        }
        if let errorObj = json["error"] as? [String: Any],
           let details = errorObj["details"] as? [String: Any],
           !details.isEmpty {
            let fieldErrors = details.compactMap { (field, value) -> String? in
                let label = fieldLabels[field] ?? field
                let msg: String
                if let arr = value as? [String] { msg = arr.first ?? "" }
                else { msg = "\(value)" }
                return "• \(label): \(msg)"
            }.joined(separator: "\n")
            return "\(base)\n\(fieldErrors)"
        }
        return base
    }
}
