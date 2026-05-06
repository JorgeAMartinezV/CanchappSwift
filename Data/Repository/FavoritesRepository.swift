import Foundation

@MainActor
final class FavoritesRepository {

    private let storage = LocalStorage.shared

    func loadAll() -> [CanchaFavorita] {
        storage.loadFavoritas()
    }

    func add(_ cancha: CanchaFavorita) {
        var all = storage.loadFavoritas()
        guard !all.contains(where: { $0.complexId == cancha.complexId }) else { return }
        all.append(cancha)
        storage.saveFavoritas(all)
    }

    func remove(complexId: String) {
        var all = storage.loadFavoritas()
        all.removeAll { $0.complexId == complexId }
        storage.saveFavoritas(all)
    }

    func isFavorita(complexId: String) -> Bool {
        storage.loadFavoritas().contains { $0.complexId == complexId }
    }
}
