import Foundation

/// Equivalent of Kotlin's FavoritesViewModel (AndroidViewModel).
/// Shared via @EnvironmentObject so all views access the same instance.
@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published var favoritas: [CanchaFavorita] = []

    var totalFavoritas: Int { favoritas.count }

    private let repository = FavoritesRepository()

    init() {
        favoritas = repository.loadAll()
    }

    func addFavorita(_ cancha: CanchaFavorita) {
        repository.add(cancha)
        favoritas = repository.loadAll()
    }

    func removeFavorita(complexId: String) {
        repository.remove(complexId: complexId)
        favoritas = repository.loadAll()
    }

    /// Synchronous check — no coroutine needed since data is in-memory.
    func isFavorita(complexId: String) -> Bool {
        favoritas.contains { $0.complexId == complexId }
    }
}
