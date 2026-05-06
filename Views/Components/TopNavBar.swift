import SwiftUI

/// Equivalent of Kotlin's TopNavBar.kt component
struct TopNavBar: View {

    var onMenuClick:     () -> Void
    var onSearchClick:   () -> Void = {}
    var onLocationClick: () -> Void = {}

    var body: some View {
        HStack(spacing: 4) {
            // Hamburger menu
            Button(action: onMenuClick) {
                Image(systemName: "line.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            // Logo + name
            HStack(spacing: 8) {
                Image("cuypequeniologo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                Text("CanchApp")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.hGreenAccent)
            }

            Spacer()

            // Action icons
            HStack(spacing: 0) {
                Button(action: onSearchClick) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 44)
                }
                Button(action: onLocationClick) {
                    Image(systemName: "location")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 44)
                }
                // Notification bell with dot
                ZStack(alignment: .topTrailing) {
                    Button {} label: {
                        Image(systemName: "bell")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 44)
                    }
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: -6, y: 8)
                }
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 64)
        .background(
            Color(appHex: 0x1A2218)
                .ignoresSafeArea(edges: .top)
        )
    }
}
