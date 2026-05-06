import Foundation

/// Equivalent of Kotlin's ComplexViewModel.
@MainActor
final class ComplexViewModel: ObservableObject {

    @Published var complexesState: Resource<ComplexListResponse>? = nil

    private var userLat: Double? = nil
    private var userLon: Double? = nil
    private let repository = ComplexRepository()

    init() {
        loadComplexes()
    }

    func updateLocation(lat: Double, lon: Double) {
        userLat = lat
        userLon = lon
        loadComplexes()
    }

    func loadComplexes(page: Int = 1) {
        complexesState = .loading
        Task {
            complexesState = await repository.getComplexes(page: page, lat: userLat, lon: userLon)
        }
    }
}
