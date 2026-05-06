import Foundation

/// JSON-file based local persistence.
/// Replaces Room Database — stores entities as JSON files in the app's Documents directory.
@MainActor
final class LocalStorage {

    static let shared = LocalStorage()

    private let favoritasFile = "canchas_favoritas.json"
    private let reservasFile  = "reservas.json"

    private var docsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // MARK: - CanchaFavorita

    func loadFavoritas() -> [CanchaFavorita] {
        let url = docsURL.appendingPathComponent(favoritasFile)
        guard let data = try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([CanchaFavorita].self, from: data)) ?? []
    }

    func saveFavoritas(_ items: [CanchaFavorita]) {
        let url = docsURL.appendingPathComponent(favoritasFile)
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: url, options: .atomic)
        }
    }

    // MARK: - Reserva

    func loadReservas() -> [Reserva] {
        let url = docsURL.appendingPathComponent(reservasFile)
        guard let data = try? Data(contentsOf: url) else { return [] }
        return (try? JSONDecoder().decode([Reserva].self, from: data)) ?? []
    }

    func saveReservas(_ items: [Reserva]) {
        let url = docsURL.appendingPathComponent(reservasFile)
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: url, options: .atomic)
        }
    }
}
