import Foundation

@MainActor
final class ReservaRepository {

    private let storage = LocalStorage.shared

    func loadAll() -> [Reserva] {
        storage.loadReservas()
    }

    func add(_ reserva: Reserva) {
        var all = storage.loadReservas()
        all.append(reserva)
        storage.saveReservas(all)
    }

    func remove(id: UUID) {
        var all = storage.loadReservas()
        all.removeAll { $0.id == id }
        storage.saveReservas(all)
    }
}
