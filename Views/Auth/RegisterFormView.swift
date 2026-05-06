import SwiftUI

/// Equivalent of Kotlin's RegisterFormScreen.kt
struct RegisterFormView: View {

    var onRegisterSuccess: () -> Void
    var onLoginClick:      () -> Void

    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var username        = ""
    @State private var email           = ""
    @State private var firstName       = ""
    @State private var lastName        = ""
    @State private var password        = ""
    @State private var confirmPassword = ""
    @State private var passwordVisible = false
    @State private var selectedRole    = "Player"
    @State private var localError: String? = nil

    private let roles      = ["Player", "Owner"]
    private let roleLabels = ["Player": "Jugador", "Owner": "Propietario de cancha"]

    private var isLoading: Bool     { authViewModel.registerState?.isLoading ?? false }
    private var isSuccess: Bool     { authViewModel.registerState?.isSuccess ?? false }
    private var successUser: UserDto? { authViewModel.registerState?.successValue?.data }
    private var serverError: String?  { authViewModel.registerState?.errorMessage }
    private var errorMessage: String? { localError ?? serverError }

    private var allFieldsFilled: Bool {
        !username.isEmpty && !email.isEmpty && !firstName.isEmpty &&
        !lastName.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.greenLight, .greenDark], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack {
                    Spacer().frame(height: 40)

                    VStack(spacing: 12) {
                        Image("cuypequeniologo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 18))

                        Text("Completa tu Registro")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(.textDark)

                        Spacer().frame(height: 2)

                        // State banners
                        if isSuccess {
                            successBanner
                        } else if isLoading {
                            loadingBanner
                        } else if let msg = errorMessage {
                            errorBanner(msg)
                        }

                        // Form fields
                        RegField("Usuario", text: $username) { localError = nil }
                        RegField("Correo electrónico", text: $email, type: .emailAddress) { localError = nil }

                        HStack(spacing: 8) {
                            RegField("Nombre",   text: $firstName) { localError = nil }
                            RegField("Apellido", text: $lastName)  { localError = nil }
                        }

                        PasswordFieldView("Contraseña",         text: $password,        visible: $passwordVisible) { localError = nil }

                        let mismatch = !confirmPassword.isEmpty && password != confirmPassword
                        VStack(alignment: .leading, spacing: 4) {
                            PasswordFieldView("Confirmar contraseña", text: $confirmPassword, visible: $passwordVisible) { localError = nil }
                            if mismatch {
                                Text("Las contraseñas no coinciden")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(appHex: 0xB71C1C))
                            }
                        }

                        // Role picker (segmented)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Tipo de cuenta")
                                .font(.system(size: 13))
                                .foregroundColor(.subtitleGray)
                            Picker("Tipo de cuenta", selection: $selectedRole) {
                                ForEach(roles, id: \.self) { role in
                                    Text(roleLabels[role] ?? role).tag(role)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        Spacer().frame(height: 4)

                        // Submit button
                        Button {
                            guard password == confirmPassword else {
                                localError = "Las contraseñas no coinciden"
                                return
                            }
                            localError = nil
                            authViewModel.resetRegisterState()
                            authViewModel.register(
                                email:     email.trimmingCharacters(in: .whitespaces),
                                firstName: firstName.trimmingCharacters(in: .whitespaces),
                                lastName:  lastName.trimmingCharacters(in: .whitespaces),
                                password:  password,
                                roleName:  selectedRole,
                                username:  username.trimmingCharacters(in: .whitespaces)
                            )
                        } label: {
                            Text("Crear Cuenta")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                        }
                        .background(!isLoading && allFieldsFilled ? Color.greenPrimary : Color.greenPrimary.opacity(0.5))
                        .cornerRadius(12)
                        .disabled(isLoading || !allFieldsFilled)

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

                    Spacer().frame(height: 40)
                }
            }
        }
        .onChange(of: isSuccess) { _, success in
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    authViewModel.resetRegisterState()
                    onRegisterSuccess()
                }
            }
        }
    }

    // MARK: - State banners

    private var successBanner: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text("✓").font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                Text("¡Cuenta creada exitosamente!")
                    .font(.system(size: 14, weight: .semibold)).foregroundColor(.white)
            }
            if let u = successUser {
                Text("Bienvenido/a, \(u.firstName) \(u.lastName)")
                    .font(.system(size: 13)).foregroundColor(.white.opacity(0.88))
                Text("Redirigiendo al inicio de sesión...")
                    .font(.system(size: 12)).foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(appHex: 0x2E7D32))
        .cornerRadius(8)
    }

    private var loadingBanner: some View {
        HStack(spacing: 10) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .greenPrimary))
                .scaleEffect(0.8)
            Text("Creando tu cuenta...")
                .font(.system(size: 13))
                .foregroundColor(Color(appHex: 0x2E7D32))
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(appHex: 0xE8F5E9))
        .cornerRadius(8)
    }

    private func errorBanner(_ msg: String) -> some View {
        Text(msg)
            .font(.system(size: 13))
            .foregroundColor(Color(appHex: 0xB71C1C))
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(appHex: 0xFFEBEE))
            .cornerRadius(8)
    }
}

// MARK: - Reusable field subviews

private struct RegField: View {
    let label: String
    @Binding var text: String
    var type: UIKeyboardType = .default
    var onChange: () -> Void

    init(_ label: String, text: Binding<String>, type: UIKeyboardType = .default, onChange: @escaping () -> Void = {}) {
        self.label    = label
        self._text    = text
        self.type     = type
        self.onChange = onChange
    }

    var body: some View {
        TextField(label, text: $text)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .keyboardType(type)
            .onChange(of: text) { _, _ in onChange() }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.greenPrimary.opacity(0.5), lineWidth: 1))
            .cornerRadius(12)
    }
}

private struct PasswordFieldView: View {
    let label: String
    @Binding var text: String
    @Binding var visible: Bool
    var onChange: () -> Void

    init(_ label: String, text: Binding<String>, visible: Binding<Bool>, onChange: @escaping () -> Void = {}) {
        self.label = label
        self._text = text
        self._visible = visible
        self.onChange = onChange
    }

    var body: some View {
        HStack {
            if visible {
                TextField(label, text: $text)
                    .textInputAutocapitalization(.never)
                    .onChange(of: text) { _, _ in onChange() }
            } else {
                SecureField(label, text: $text)
                    .onChange(of: text) { _, _ in onChange() }
            }
            Button { visible.toggle() } label: {
                Image(systemName: visible ? "eye" : "eye.slash")
                    .foregroundColor(.subtitleGray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.greenPrimary.opacity(0.5), lineWidth: 1))
        .cornerRadius(12)
    }
}
