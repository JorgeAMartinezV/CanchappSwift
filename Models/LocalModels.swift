import Foundation

// MARK: - Local persistence models (equivalent of Room entities)

struct CanchaFavorita: Codable, Identifiable {
    var id: String { complexId }
    let complexId: String
    let name: String
    let address: String
    let city: String
    let minPrice: Double
    let fieldsCount: Int
    var distanceKm: Double?
    var timestamp: TimeInterval = Date().timeIntervalSince1970
}

struct Reserva: Codable, Identifiable {
    var id: UUID = UUID()
    let complexId: String
    let complexName: String
    let address: String
    let city: String
    let fecha: String        // "2026-04-09"
    let hora: String         // "10:00"
    let duracionHoras: Int
    let precioTotal: Double
    var timestamp: TimeInterval = Date().timeIntervalSince1970
}
