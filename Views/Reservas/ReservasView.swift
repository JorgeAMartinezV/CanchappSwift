import SwiftUI

/// Equivalent of Kotlin's MisReservasScreen.kt
struct ReservasView: View {

    var onBack: () -> Void

    @EnvironmentObject var viewModel: ReservasViewModel

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
                Text("Mis Reservas")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Spacer().frame(width: 44)
            }
            .padding(.horizontal, 8)
            .frame(height: 64)
            .background(Color.hNavDark.ignoresSafeArea(edges: .top))

            if viewModel.reservas.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.reservas) { reserva in
                            ReservaCard(reserva: reserva) {
                                viewModel.remove(id: reserva.id)
                            }
                        }
                    }
                    .padding(16)
                }
            }
        }
        .background(Color(appHex: 0xF5F5F5).ignoresSafeArea())
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "calendar.badge.minus")
                .font(.system(size: 60))
                .foregroundColor(.hTextGray)
            Text("No tenés reservas todavía")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.hTextGray)
            Text("Reservá desde la lista de complejos")
                .font(.system(size: 13))
                .foregroundColor(.hTextGray)
            Spacer()
        }
        .padding(32)
    }
}

// MARK: - Reserva card

private struct ReservaCard: View {
    let reserva: Reserva
    let onDelete: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.hNavDark)
                    .frame(width: 48, height: 48)
                Image(systemName: "calendar.badge.checkmark")
                    .font(.system(size: 22))
                    .foregroundColor(.hGreenAccent)
            }

            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(reserva.complexName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.hTextDark)

                HStack(spacing: 2) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.hTextGray)
                    Text("\(reserva.address), \(reserva.city)")
                        .font(.system(size: 12))
                        .foregroundColor(.hTextGray)
                        .lineLimit(1)
                }

                HStack(spacing: 6) {
                    InfoPill(reserva.fecha)
                    InfoPill("\(reserva.hora)hs")
                    InfoPill("\(reserva.duracionHoras)h")
                }
                .padding(.top, 2)

                Text("Total: $\(Int(reserva.precioTotal / 1000))k")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.hGreenAccent)
                    .padding(.top, 2)
            }

            Spacer()

            // Delete button
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(Color(appHex: 0xE53935))
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 3)
    }
}

private struct InfoPill: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(Color(appHex: 0x2E7D32))
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(Color(appHex: 0xE8F5E9))
            .cornerRadius(20)
    }
}
