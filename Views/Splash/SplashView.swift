import SwiftUI

/// Equivalent of Kotlin's SplashScreen.kt
struct SplashView: View {

    var onDismiss: () -> Void

    private let bgTop      = Color(appHex: 0x1A2218)
    private let bgBot      = Color(appHex: 0x0F1A0D)
    private let green      = Color(appHex: 0x4CAF50)
    private let lightGreen = Color(appHex: 0x81C784)
    private let muted      = Color(appHex: 0xB0BEC5)

    var body: some View {
        ZStack {
            LinearGradient(colors: [bgTop, bgBot], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(green.opacity(0.15))
                        .frame(width: 110, height: 110)
                    Image("cuypequeniologo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                }

                Spacer().frame(height: 28)

                Text("CanchApp")
                    .font(.system(size: 42, weight: .heavy))
                    .foregroundColor(green)

                Spacer().frame(height: 8)

                Text("Encuentra tu cancha ideal")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(lightGreen)

                Spacer().frame(height: 4)

                Text("Reserva · Juega · Disfruta")
                    .font(.system(size: 13))
                    .italic()
                    .foregroundColor(muted)

                Spacer().frame(height: 48)

                Rectangle()
                    .fill(green.opacity(0.4))
                    .frame(height: 1)
                    .padding(.horizontal, 40)

                Spacer().frame(height: 24)

                Text("Toca para continuar")
                    .font(.system(size: 13))
                    .foregroundColor(muted)
            }
            .padding(.horizontal, 32)
        }
        .onTapGesture { onDismiss() }
    }
}
