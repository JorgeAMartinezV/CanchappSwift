import SwiftUI

/// Root navigation state machine.
/// Equivalent of Kotlin's AppScreen enum + MainActivity when-block.
enum AppScreen {
    case splash
    case registerLanding
    case login
    case registerForm
    case home
    case favorites
    case reservas
}

struct ContentView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var currentScreen: AppScreen = .splash

    var body: some View {
        Group {
            switch currentScreen {

            case .splash:
                SplashView {
                    currentScreen = .registerLanding
                }

            case .registerLanding:
                RegisterLandingView(
                    onRegisterWithEmail: { currentScreen = .registerForm },
                    onLoginClick:        { currentScreen = .login }
                )

            case .login:
                LoginView(
                    onLoginSuccess:  { currentScreen = .home },
                    onRegisterClick: { currentScreen = .registerLanding }
                )

            case .registerForm:
                RegisterFormView(
                    onRegisterSuccess: { currentScreen = .login },
                    onLoginClick:      { currentScreen = .login }
                )

            case .home:
                HomeView(
                    onLogout: {
                        authViewModel.logout()
                        currentScreen = .login
                    },
                    onNavigateToFavorites: { currentScreen = .favorites },
                    onNavigateToReservas:  { currentScreen = .reservas }
                )

            case .favorites:
                FavoritesView(onBack: { currentScreen = .home })

            case .reservas:
                ReservasView(onBack: { currentScreen = .home })
            }
        }
        .animation(.easeInOut(duration: 0.2), value: currentScreen)
    }
}
