import Foundation

@MainActor
final class ComplexRepository {

    private let api = APIService.shared

    func getComplexes(
        page: Int = 1,
        lat: Double? = nil,
        lon: Double? = nil
    ) async -> Resource<ComplexListResponse> {
        do {
            let response = try await api.getComplexes(page: page, lat: lat, lon: lon)
            if response.success {
                return .success(response)
            }
            return .error(response.message ?? "Error al obtener complejos")
        } catch {
            if let urlError = error as? URLError,
               urlError.code == .notConnectedToInternet || urlError.code == .networkConnectionLost {
                return .error("Sin conexión a internet")
            }
            return .error("Error inesperado: \(error.localizedDescription)")
        }
    }
}
