import SwiftUI

// MARK: - App entry point
// ──────────────────────────────────────────────────────────────────────────────
// SETUP INSTRUCTIONS (do this once in Xcode):
//
// 1. File > New > Project > App  (name: CanchApp, interface: SwiftUI, iOS 16+)
// 2. Delete the generated ContentView.swift Xcode creates and replace with
//    the files inside ios/CanchApp/ from this repository.
// 3. Add these files to the Xcode target (drag & drop or File > Add Files).
// 4. Add your logo: drag cuypequeniologo.png into Assets.xcassets
//    and name it "cuypequeniologo".
// 5. In Info.plist add:
//      NSLocationWhenInUseUsageDescription  →  "Para mostrarte canchas cercanas"
// 6. Build & Run (⌘+R).
// ──────────────────────────────────────────────────────────────────────────────

@main
struct CanchAppApp: App {

    // Shared ViewModels — injected as EnvironmentObjects so every view
    // in the hierarchy can access them (equivalent of Hilt singleton scope).
    @StateObject private var authViewModel      = AuthViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @StateObject private var reservasViewModel  = ReservasViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(favoritesViewModel)
                .environmentObject(reservasViewModel)
        }
    }
}
