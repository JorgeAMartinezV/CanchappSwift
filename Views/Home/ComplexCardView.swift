import SwiftUI

/// Equivalent of Kotlin's ComplexCard composable.
/// Uses @EnvironmentObject to share FavoritesViewModel and ReservasViewModel.
struct ComplexCardView: View {

    let complex: ComplexDto

    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var reservasVM:  ReservasViewModel

    @State private var showReservaDialog = false

    private var isFavorita: Bool {
        favoritesVM.isFavorita(complexId: complex.complexId)
    }

    var body: some View {
        VStack(spacing: 0) {

            // ── IMAGE AREA ────────────────────────────────────────────
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.hCardDarkGreen)
                    .frame(height: 160)

                Image(systemName: "building.2")
                    .font(.system(size: 72))
                    .foregroundColor(.white.opacity(0.25))
                    .frame(height: 160, alignment: .center)

                // Top row: favorite (left) + distance (right)
                HStack {
                    Button { toggleFavorite() } label: {
                        Image(systemName: isFavorita ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(isFavorita ? .hGreenAccent : .hTextGray)
                    }
                    .padding(10)

                    Spacer()

                    HStack(spacing: 3) {
                        Image(systemName: "location.fill").font(.system(size: 10))
                        Text(complex.distanceKm.map { String(format: "%.1f km", $0) } ?? "N/A")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Color.hNavDark)
                    .cornerRadius(20)
                    .padding(10)
                }
                .frame(height: 160, alignment: .top)

                // Bottom row: city (left) + fields count (right)
                HStack {
                    HStack(spacing: 3) {
                        Image(systemName: "location.fill").font(.system(size: 9))
                        Text(complex.city).font(.system(size: 10))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Color.hNavDark).cornerRadius(20)

                    Spacer()

                    HStack(spacing: 3) {
                        Image(systemName: "sportscourt").font(.system(size: 9))
                        Text("\(complex.fieldsCount) canchas").font(.system(size: 10))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Color.hNavDark).cornerRadius(20)
                }
                .padding(10)
                .frame(height: 160, alignment: .bottom)
            }
            .clipShape(Rectangle())

            // ── INFO AREA ─────────────────────────────────────────────
            VStack(alignment: .leading, spacing: 0) {
                Text(complex.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.hTextDark)
                Spacer().frame(height: 4)
                Text(complex.address)
                    .font(.system(size: 13))
                    .foregroundColor(.hTextGray)
                Spacer().frame(height: 14)

                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Desde")
                            .font(.system(size: 11))
                            .foregroundColor(.hTextGray)
                        Text("$\(Int(complex.minPrice / 1000))k /hr")
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundColor(.hTextDark)
                    }
                    Spacer()
                    HStack(spacing: 8) {
                        // Reservar (outlined)
                        Button { showReservaDialog = true } label: {
                            Text("Reservar")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.hGreenAccent)
                                .padding(.horizontal, 14).padding(.vertical, 10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(Color.hGreenAccent, lineWidth: 1)
                                )
                        }
                        // Ver canchas (filled)
                        Button {} label: {
                            Text("Ver canchas →")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20).padding(.vertical, 10)
                                .background(Color.hGreenAccent)
                                .cornerRadius(24)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .sheet(isPresented: $showReservaDialog) {
            ReservaDialogView(
                complex:   complex,
                onConfirm: { reserva in
                    reservasVM.add(reserva)
                    showReservaDialog = false
                },
                onDismiss: { showReservaDialog = false }
            )
        }
    }

    // MARK: - Favorite toggle

    private func toggleFavorite() {
        if isFavorita {
            favoritesVM.removeFavorita(complexId: complex.complexId)
        } else {
            favoritesVM.addFavorita(
                CanchaFavorita(
                    complexId:   complex.complexId,
                    name:        complex.name,
                    address:     complex.address,
                    city:        complex.city,
                    minPrice:    complex.minPrice,
                    fieldsCount: complex.fieldsCount,
                    distanceKm:  complex.distanceKm
                )
            )
        }
    }
}
