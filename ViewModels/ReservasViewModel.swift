import Foundation

/// Equivalent of Kotlin's ReservasViewModel (AndroidViewModel).
/// Shared via @EnvironmentObject so all views access the same instance.
@MainActor
final class ReservasViewModel: ObservableObject {

    @Published var reservas: [Reserva] = []

    private let repository = ReservaRepository()

    init() {
        reservas = repository.loadAll()
    }

    func add(_ reserva: Reserva) {
        repository.add(reserva)
        reservas = repository.loadAll()
    }

    func remove(id: UUID) {
        repository.remove(id: id)
        reservas = repository.loadAll()
    }
}
