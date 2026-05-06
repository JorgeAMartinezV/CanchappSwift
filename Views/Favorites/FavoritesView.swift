import SwiftUI

/// Equivalent of Kotlin's FavoritesScreen.kt
struct FavoritesView: View {

    var onBack: () -> Void

    @EnvironmentObject var viewModel: FavoritesViewModel

    var body: some View {
        VStack(spacing: 0) {

            // ── TOP BAR ───────────────────────────────────────────────
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
                Spacer()
                Text("Mis Favoritos")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Spacer().frame(width: 44) // visual balance
            }
            .padding(.horizontal, 8)
            .frame(height: 64)
            .background(Color.hNavDark.ignoresSafeArea(edges: .top))

            if viewModel.favoritas.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        Text("\(viewModel.totalFavoritas) favorita\(viewModel.totalFavoritas != 1 ? "s" : "")")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.hTextGray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 8)

                        ForEach(viewModel.favoritas) { cancha in
                            FavoritaCard(cancha: cancha) {
                                viewModel.removeFavorita(complexId: cancha.complexId)
                            }
                        }
                    }
                    .padding(16)
                }
            }
        }
        .background(Color.hWhiteBg.ignoresSafeArea())
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "heart.slash")
                .font(.system(size: 64))
                .foregroundColor(.hTextGray)
            Text("No tienes favoritos aún")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.hTextDark)
            Text("Agrega canchas a favoritos para verlas aquí")
                .font(.system(size: 14))
                .foregroundColor(.hTextGray)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(32)
    }
}

// MARK: - Favorita card

private struct FavoritaCard: View {
    let cancha: CanchaFavorita
    let onRemove: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            // Header
            HStack {
                Text(cancha.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: onRemove) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.hGreenAccent)
                }
            }
            .padding(12)
            .background(Color.hCardDarkGreen)

            // Details
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 4) {
                    Text("📍")
                    VStack(alignment: .leading, spacing: 2) {
                        Text(cancha.address)
                            .font(.system(size: 13))
                            .foregroundColor(.hTextDark)
                        Text(cancha.city)
                            .font(.system(size: 12))
                            .foregroundColor(.hTextGray)
                    }
                }

                HStack(spacing: 16) {
                    Label("\(cancha.fieldsCount) canchas", systemImage: "sportscourt")
                        .font(.system(size: 12))
                        .foregroundColor(.hTextGray)
                    Label("Desde $\(Int(cancha.minPrice / 1000))k/hr", systemImage: "tag")
                        .font(.system(size: 12))
                        .foregroundColor(.hTextGray)
                    if let dist = cancha.distanceKm {
                        Label(String(format: "%.1f km", dist), systemImage: "location")
                            .font(.system(size: 12))
                            .foregroundColor(.hTextGray)
                    }
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}
