import SwiftUI

enum ChemVaultTheme {
    static let background = Color(red: 0.045, green: 0.055, blue: 0.075)
    static let card = Color(red: 0.105, green: 0.115, blue: 0.145)
    static let elevatedCard = Color(red: 0.145, green: 0.155, blue: 0.190)

    static let accent = Color(red: 1.00, green: 0.80, blue: 0.25)
    static let softAccent = Color(red: 1.00, green: 0.90, blue: 0.55)
    static let success = Color(red: 0.25, green: 0.85, blue: 0.55)
    static let warning = Color(red: 1.00, green: 0.45, blue: 0.35)

    static let text = Color.white
    static let secondaryText = Color.white.opacity(0.70)
    static let tertiaryText = Color.white.opacity(0.48)

    static let cornerRadius: CGFloat = 24
}
