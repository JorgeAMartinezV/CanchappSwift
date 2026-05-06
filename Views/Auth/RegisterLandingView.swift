import SwiftUI

/// Equivalent of Kotlin's RegisterScreen.kt (landing with social options).
struct RegisterLandingView: View {

    var onRegisterWithEmail:     () -> Void
    var onLoginClick:            () -> Void
    var onRegisterWithGoogle:    () -> Void = {}
    var onRegisterWithInstagram: () -> Void = {}
    var onRegisterWithTikTok:    () -> Void = {}

    var body: some View {
        ZStack {
            LinearGradient(colors: [.greenLight, .greenDark], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack {
                    Spacer().frame(height: 60)

                    VStack(spacing: 12) {
                        Image("cuypequeniologo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 18))

                        Spacer().frame(height: 4)

                        Text("Crear Cuenta")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundColor(.textDark)

                        Text("Únete a miles de jugadores encontrando su cancha perfecta")
                            .font(.system(size: 14))
                            .foregroundColor(.subtitleGray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)

                        Spacer().frame(height: 8)

                        // Google
                        GradientSocialButton(
                            text: "Registrarse con Google",
                            gradient: LinearGradient(
                                colors: [Color(appHex: 0x4285F4), Color(appHex: 0x34A853)],
                                startPoint: .leading, endPoint: .trailing
                            ),
                            action: onRegisterWithGoogle
                        )

                        // Instagram
                        GradientSocialButton(
                            text: "Registrarse con Instagram",
                            gradient: LinearGradient(
                                colors: [Color(appHex: 0xF58529), Color(appHex: 0xDD2A7B)],
                                startPoint: .leading, endPoint: .trailing
                            ),
                            action: onRegisterWithInstagram
                        )

                        // TikTok
                        SocialIconButton(
                            text: "Registrarse con TikTok",
                            icon: "music.note",
                            bgColor: Color(appHex: 0x010101),
                            action: onRegisterWithTikTok
                        )

                        // Divider "o"
                        HStack {
                            Rectangle().fill(Color(appHex: 0xBDBDBD)).frame(height: 1)
                            Text("o")
                                .font(.system(size: 13))
                                .foregroundColor(.subtitleGray)
                                .padding(.horizontal, 8)
                            Rectangle().fill(Color(appHex: 0xBDBDBD)).frame(height: 1)
                        }

                        // Email
                        SocialIconButton(
                            text: "Registrarse con Correo",
                            icon: "envelope.fill",
                            bgColor: .greenPrimary,
                            action: onRegisterWithEmail
                        )

                        Spacer().frame(height: 4)

                        // Footer
                        HStack(spacing: 0) {
                            Text("¿Ya tienes cuenta? ")
                                .font(.system(size: 14))
                                .foregroundColor(.subtitleGray)
                            Button("Inicia sesión") { onLoginClick() }
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.linkGreen)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                    .background(Color.cardBg)
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 60)
                }
            }
        }
    }
}

// MARK: - Private helpers

private struct GradientSocialButton: View {
    let text: String
    let gradient: LinearGradient
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
        }
        .background(gradient)
        .cornerRadius(12)
    }
}

private struct SocialIconButton: View {
    let text: String
    let icon: String
    let bgColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                Text(text)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
        }
        .background(bgColor)
        .cornerRadius(12)
    }
}
