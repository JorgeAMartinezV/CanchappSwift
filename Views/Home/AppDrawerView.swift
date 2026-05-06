import SwiftUI

/// Equivalent of Kotlin's AppDrawerContent composable.
/// Slides in from the left as part of a ZStack in HomeView.
struct AppDrawerView: View {

    var user: UserDto?
    var onClose:               () -> Void
    var onLogout:              () -> Void
    var onNavigateToFavorites: () -> Void
    var onNavigateToReservas:  () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── HEADER ────────────────────────────────────────────────
            HStack {
                Image("cuypequeniologo")
                    .resizable().scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                Text("CanchApp")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.hGreenAccent)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                Color(appHex: 0x1A2218)
                    .ignoresSafeArea(edges: .top)
            )

            // ── USER INFO ─────────────────────────────────────────────
            if let user = user {
                HStack(spacing: 12) {
                    ZStack {
                        Circle().fill(Color.hGreenAccent).frame(width: 48, height: 48)
                        Image("cuypequeniologo")
                            .resizable().scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(user.firstName) \(user.lastName)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.hTextDark)
                        Text(user.email)
                            .font(.system(size: 12))
                            .foregroundColor(.hTextGray)
                            .lineLimit(1)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                Divider()
            }

            Spacer().frame(height: 8)

            // ── MENU ITEMS ────────────────────────────────────────────
            DrawerMenuItem(icon: "house.fill",      label: "Inicio") {}
            DrawerMenuItem(icon: "magnifyingglass", label: "Buscar Canchas") {}
            DrawerMenuItem(icon: "calendar.badge.checkmark", label: "Mis Reservas") {
                onClose(); onNavigateToReservas()
            }
            DrawerMenuItem(icon: "heart.fill", label: "Favoritos") {
                onClose(); onNavigateToFavorites()
            }

            Divider()
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

            DrawerMenuItem(icon: "person.fill", label: "Mi Perfil") {}

            Spacer()

            // ── CERRAR SESIÓN ─────────────────────────────────────────
            DrawerMenuItem(
                icon: "rectangle.portrait.and.arrow.right",
                label: "Cerrar Sesión",
                isDestructive: true
            ) {
                onLogout()
            }
            .padding(.bottom, 8)
        }
        .frame(maxHeight: .infinity)
        .background(Color.white)
        .shadow(color: .black.opacity(0.25), radius: 8, x: 4, y: 0)
    }
}

// MARK: - Private row component

private struct DrawerMenuItem: View {
    let icon: String
    let label: String
    var isDestructive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isDestructive ? Color(appHex: 0xE53935) : .hTextDark)
                    .frame(width: 24)
                Text(label)
                    .font(.system(size: 15, weight: isDestructive ? .semibold : .medium))
                    .foregroundColor(isDestructive ? Color(appHex: 0xE53935) : .hTextDark)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
    }
}
