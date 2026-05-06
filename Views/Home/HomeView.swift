import SwiftUI

/// Equivalent of Kotlin's HomeScreen composable.
struct HomeView: View {

    var onLogout:              () -> Void
    var onNavigateToFavorites: () -> Void
    var onNavigateToReservas:  () -> Void

    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var favoritesVM:   FavoritesViewModel
    @EnvironmentObject var reservasVM:    ReservasViewModel

    @StateObject private var complexVM      = ComplexViewModel()
    @StateObject private var locationHelper = LocationHelper()

    @State private var isDrawerOpen = false
    @State private var searchQuery  = ""
    @State private var showMap      = false

    var body: some View {
        ZStack(alignment: .leading) {

            // ── MAIN CONTENT ──────────────────────────────────────────
            VStack(spacing: 0) {
                TopNavBar(
                    onMenuClick: {
                        withAnimation(.easeInOut(duration: 0.25)) { isDrawerOpen = true }
                    }
                )

                // List / Map tab row
                HStack(spacing: 8) {
                    TabChip(label: "Lista", icon: "list.bullet", selected: !showMap) { showMap = false }
                    TabChip(label: "Mapa",  icon: "map",         selected:  showMap) { showMap = true  }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                // Location denied banner
                if locationHelper.locationDenied {
                    HStack(spacing: 8) {
                        Image(systemName: "location.slash")
                            .font(.system(size: 14))
                            .foregroundColor(Color(appHex: 0xE65100))
                        Text("Sin ubicación: no se puede calcular distancia a las canchas.")
                            .font(.system(size: 12))
                            .foregroundColor(Color(appHex: 0xE65100))
                        Spacer()
                    }
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(Color(appHex: 0xFFF3E0))
                    .cornerRadius(8)
                    .padding(.horizontal, 16).padding(.bottom, 4)
                }

                if showMap {
                    mapPlaceholder
                } else {
                    listContent
                }
            }
            .background(Color.hWhiteBg.ignoresSafeArea())
            .disabled(isDrawerOpen)

            // ── DIMMING OVERLAY ───────────────────────────────────────
            if isDrawerOpen {
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) { isDrawerOpen = false }
                    }
            }

            // ── DRAWER ────────────────────────────────────────────────
            AppDrawerView(
                user:                    authViewModel.loggedUser,
                onClose:                 { withAnimation(.easeInOut(duration: 0.25)) { isDrawerOpen = false } },
                onLogout:                { withAnimation { isDrawerOpen = false }; onLogout() },
                onNavigateToFavorites:   { withAnimation { isDrawerOpen = false }; onNavigateToFavorites() },
                onNavigateToReservas:    { withAnimation { isDrawerOpen = false }; onNavigateToReservas() }
            )
            .frame(width: 280)
            .offset(x: isDrawerOpen ? 0 : -280)
        }
        .animation(.easeInOut(duration: 0.25), value: isDrawerOpen)
        .onAppear {
            Task {
                let loc = await locationHelper.requestCurrentLocation()
                if let loc {
                    complexVM.updateLocation(
                        lat: loc.coordinate.latitude,
                        lon: loc.coordinate.longitude
                    )
                }
            }
        }
    }

    // MARK: - Map placeholder (Mapbox deferred)

    private var mapPlaceholder: some View {
        ZStack {
            Color(appHex: 0xE8F5E9).ignoresSafeArea(edges: .bottom)
            VStack(spacing: 12) {
                Image(systemName: "map")
                    .font(.system(size: 60))
                    .foregroundColor(Color.hGreenAccent.opacity(0.4))
                Text("Mapa próximamente")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.hTextGray)
            }
        }
    }

    // MARK: - List content

    private var listContent: some View {
        ScrollView {
            LazyVStack(spacing: 16) {

                // Section header
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.hGreenAccent)
                        Text("Complejos Cercanos")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.hTextDark)
                    }
                    Spacer()
                    Button { complexVM.loadComplexes() } label: {
                        Text("Ver todos →")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.hGreenAccent)
                    }
                }
                .padding(.horizontal, 16)

                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(.hTextGray)
                    TextField("Buscar complejo...", text: $searchQuery)
                        .disableAutocorrection(true)
                    if !searchQuery.isEmpty {
                        Button { searchQuery = "" } label: {
                            Image(systemName: "xmark.circle.fill").foregroundColor(.hTextGray)
                        }
                    }
                }
                .padding(.horizontal, 14).padding(.vertical, 12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            searchQuery.isEmpty ? Color(appHex: 0xDDDDDD) : Color.hGreenAccent,
                            lineWidth: 1
                        )
                )
                .cornerRadius(24)
                .padding(.horizontal, 16)

                // State-driven list
                stateContent
            }
            .padding(.vertical, 16)
        }
    }

    // MARK: - State-driven complex list

    @ViewBuilder
    private var stateContent: some View {
        if let state = complexVM.complexesState {
            switch state {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .hGreenAccent))
                    .padding(48)

            case .success(let response):
                let all = response.data?.items ?? []
                let trimmed = searchQuery.trimmingCharacters(in: .whitespaces)
                let filtered = trimmed.isEmpty
                    ? all
                    : all.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }

                if filtered.isEmpty {
                    Text(
                        trimmed.isEmpty
                            ? "No hay complejos disponibles"
                            : "Sin resultados para \"\(trimmed)\""
                    )
                    .font(.system(size: 15))
                    .foregroundColor(.hTextGray)
                    .padding(32)
                } else {
                    ForEach(filtered) { complex in
                        ComplexCardView(complex: complex)
                            .padding(.horizontal, 16)
                    }
                }

            case .error(let msg):
                HStack {
                    Text(msg)
                        .font(.system(size: 14))
                        .foregroundColor(Color(appHex: 0xB71C1C))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button { complexVM.loadComplexes() } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Color(appHex: 0xB71C1C))
                    }
                }
                .padding(16)
                .background(Color(appHex: 0xFFEBEE))
                .cornerRadius(12)
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Tab chip

private struct TabChip: View {
    let label: String
    let icon: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 13))
                Text(label).font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(selected ? .white : .hTextDark)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(selected ? Color.hGreenAccent : Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.hGreenAccent.opacity(selected ? 0 : 0.3), lineWidth: 1)
            )
        }
    }
}
