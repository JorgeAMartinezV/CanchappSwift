import Foundation

// MARK: - Login

struct LoginRequest: Encodable {
    let identifier: String
    let password: String
}

struct LoginResponse: Decodable {
    let success: Bool
    let message: String?
    let data: LoginData?
    let error: ApiError?
}

struct LoginData: Decodable {
    let access: String
    let refresh: String
    let user: UserDto
}

// MARK: - Register

struct RegisterRequest: Encodable {
    let email: String
    let firstName: String
    let lastName: String
    let password: String
    let roleName: String
    let username: String

    enum CodingKeys: String, CodingKey {
        case email, password, username
        case firstName = "f_name"
        case lastName  = "l_name"
        case roleName  = "role_name"
    }
}

struct RegisterResponse: Decodable {
    let success: Bool
    let message: String?
    let data: UserDto?
    let error: ApiError?
}

// MARK: - User

struct UserDto: Codable {
    let userId: String
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let roleName: String
    let status: String
    let avatarUrl: String?
    let isGuest: Bool

    enum CodingKeys: String, CodingKey {
        case username, email, status
        case userId    = "user_id"
        case firstName = "f_name"
        case lastName  = "l_name"
        case roleName  = "role_name"
        case avatarUrl = "avatar_url"
        case isGuest   = "is_guest"
    }
}

// MARK: - Error

struct ApiError: Decodable {
    let code: String?
    let message: String?
}

// MARK: - Complex

struct ComplexDto: Codable, Identifiable {
    var id: String { complexId }
    let complexId: String
    let ownerId: String
    let name: String
    let address: String
    let city: String
    let latitude: Double
    let longitude: Double
    let status: String
    let fieldsCount: Int
    let minPrice: Double
    let maxPrice: Double
    let distanceKm: Double?

    enum CodingKeys: String, CodingKey {
        case name, address, city, latitude, longitude, status
        case complexId   = "complex_id"
        case ownerId     = "owner_id"
        case fieldsCount = "fields_count"
        case minPrice    = "min_price"
        case maxPrice    = "max_price"
        case distanceKm  = "distance_km"
    }
}

struct ComplexListData: Decodable {
    let items: [ComplexDto]
    let total: Int
    let page: Int
    let pageSize: Int
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case items, total, page
        case pageSize   = "page_size"
        case totalPages = "total_pages"
    }
}

struct ComplexListResponse: Decodable {
    let success: Bool
    let message: String?
    let data: ComplexListData?
    let error: ApiError?
}
