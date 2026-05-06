import SwiftUI

/// Equivalent of Kotlin's LoginScreen.kt
struct LoginView: View {

    var onLoginSuccess:  () -> Void
    var onRegisterClick: () -> Void

    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var identifier      = ""
    @State private var password        = ""
    @State private var passwordVisible = false

    private var isLoading: Bool    { authViewModel.loginState?.isLoading  ?? false }
    private var isSuccess: Bool    { authViewModel.loginState?.isSuccess  ?? false }
    private var errorMessage: String? { authViewModel.loginState?.errorMessage }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.greenLight, .greenDark], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack {
                    Spacer().frame(height: 60)

                    VStack(spacing: 12) {
                        // Logo
                        Image("cuypequeniologo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 18))

                        Text("Iniciar Sesión")
                            .font(.system(size: 26, weight: .heavy))
                            .foregroundColor(.textDark)

                        Text("Ingresa tus datos para continuar")
                            .font(.system(size: 14))
                            .foregroundColor(.subtitleGray)
                            .multilineTextAlignment(.center)

                        Spacer().frame(height: 4)

                        // State banners
                        stateBanner

                        // Identifier field
                        TextField("Usuario o correo", text: $identifier)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .onChange(of: identifier) { _, _ in authViewModel.resetLoginState() }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.greenPrimary.opacity(0.5), lineWidth: 1)
                            )
                            .cornerRadius(12)

                        // Password field
                        HStack {
                            if passwordVisible {
                                TextField("Contraseña", text: $password)
                                    .textInputAutocapitalization(.never)
                                    .onChange(of: password) { _, _ in authViewModel.resetLoginState() }
                            } else {
                                SecureField("Contraseña", text: $password)
                                    .onChange(of: password) { _, _ in authViewModel.resetLoginState() }
                            }
                            Button { passwordVisible.toggle() } label: {
                                Image(systemName: passwordVisible ? "eye" : "eye.slash")
                                    .foregroundColor(.subtitleGray)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.greenPrimary.opacity(0.5), lineWidth: 1)
                        )
                        .cornerRadius(12)

                        Spacer().frame(height: 4)

                        // Login button
                        let canSubmit = !isLoading && !isSuccess && !identifier.isEmpty && !password.isEmpty
                        Button {
                            authViewModel.resetLoginState()
                            authViewModel.login(
                                identifier: identifier.trimmingCharacters(in: .whitespaces),
                                password: password
                            )
                        } label: {
                            Text("Iniciar Sesión")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                        }
                        .background(canSubmit ? Color.greenPrimary : Color.greenPrimary.opacity(0.5))
                        .cornerRadius(12)
                        .disabled(!canSubmit)

                        HStack(spacing: 0) {
                            Text("No tienes cuenta? ")
                                .font(.system(size: 14))
                                .foregroundColor(.subtitleGray)
                            Button("Regístrate") { onRegisterClick() }
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
        .onChange(of: isSuccess) { _, success in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    onLoginSuccess()
                }
            }
        }
    }

    @ViewBuilder
    private var stateBanner: some View {
        if isSuccess {
            HStack(spacing: 8) {
                Text("✓")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Text("Sesión iniciada correctamente!")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(appHex: 0x2E7D32))
            .cornerRadius(8)

        } else if isLoading {
            HStack(spacing: 10) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .greenPrimary))
                    .scaleEffect(0.8)
                Text("Verificando credenciales...")
                    .font(.system(size: 13))
                    .foregroundColor(Color(appHex: 0x2E7D32))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(appHex: 0xE8F5E9))
            .cornerRadius(8)

        } else if let msg = errorMessage {
            Text(msg)
                .font(.system(size: 13))
                .foregroundColor(Color(appHex: 0xB71C1C))
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(appHex: 0xFFEBEE))
                .cornerRadius(8)
        }
    }
}
