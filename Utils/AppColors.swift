import SwiftUI

extension Color {
    // Home / shared palette
    static let hWhiteBg       = Color(appHex: 0xF5F5F5)
    static let hGreenAccent   = Color(appHex: 0x4CAF50)
    static let hCardDarkGreen = Color(appHex: 0x2D4A27)
    static let hNavDark       = Color(appHex: 0x1A2218)
    static let hTextDark      = Color(appHex: 0x1B1B1B)
    static let hTextGray      = Color(appHex: 0x6B6B6B)

    // Auth palette
    static let greenPrimary  = Color(appHex: 0x4CAF50)
    static let greenDark     = Color(appHex: 0x388E3C)
    static let greenLight    = Color(appHex: 0x81C784)
    static let linkGreen     = Color(appHex: 0x2E7D32)
    static let cardBg        = Color(appHex: 0xFAFAFA)
    static let subtitleGray  = Color(appHex: 0x757575)
    static let textDark      = Color(appHex: 0x1B1B1B)

    /// Convenience initializer: 0xRRGGBB hex value
    init(appHex: UInt, alpha: Double = 1.0) {
        let r = Double((appHex >> 16) & 0xFF) / 255.0
        let g = Double((appHex >>  8) & 0xFF) / 255.0
        let b = Double( appHex        & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, opacity: alpha)
    }
}
