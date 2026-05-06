import Foundation

/// Equivalent of Kotlin's RetrofitClient + ApiService.
/// Uses URLSession with async/await instead of Retrofit.
@MainActor
final class APIService {

    static let shared = APIService()
    private let baseURL = "https://canchapp-backend.onrender.com"

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest  = 30
        config.timeoutIntervalForResource = 30
        return URLSession(configuration: config)
    }()

    // MARK: - Auth

    func login(
        identifier: String,
        password: String
    ) async throws -> (response: LoginResponse, rawData: Data) {
        let url = URL(string: "\(baseURL)/api/identity/auth/login/")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(LoginRequest(identifier: identifier, password: password))
        let (data, _) = try await session.data(for: req)
        guard let decoded = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
            throw URLError(.cannotParseResponse)
        }
        return (decoded, data)
    }

    func register(
        email: String,
        firstName: String,
        lastName: String,
        password: String,
        roleName: String,
        username: String
    ) async throws -> (response: RegisterResponse, rawData: Data) {
        let url = URL(string: "\(baseURL)/api/identity/register/")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(
            RegisterRequest(
                email: email, firstName: firstName, lastName: lastName,
                password: password, roleName: roleName, username: username
            )
        )
        let (data, _) = try await session.data(for: req)
        guard let decoded = try? JSONDecoder().decode(RegisterResponse.self, from: data) else {
            throw URLError(.cannotParseResponse)
        }
        return (decoded, data)
    }

    // MARK: - Complexes

    func getComplexes(
        page: Int = 1,
        lat: Double? = nil,
        lon: Double? = nil
    ) async throws -> ComplexListResponse {
        var components = URLComponents(string: "\(baseURL)/api/complexes/")!
        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        if let lat { queryItems.append(URLQueryItem(name: "lat", value: "\(lat)")) }
        if let lon { queryItems.append(URLQueryItem(name: "lon", value: "\(lon)")) }
        components.queryItems = queryItems
        let (data, _) = try await session.data(for: URLRequest(url: components.url!))
        guard let decoded = try? JSONDecoder().decode(ComplexListResponse.self, from: data) else {
            throw URLError(.cannotParseResponse)
        }
        return decoded
    }
}
