import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.030, green: 0.036, blue: 0.055),
                    Color(red: 0.055, green: 0.062, blue: 0.092),
                    Color(red: 0.018, green: 0.022, blue: 0.034)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(ChemVaultTheme.accent.opacity(0.14))
                .frame(width: 280, height: 280)
                .blur(radius: 62)
                .offset(x: -120, y: -190)

            Circle()
                .fill(Color.blue.opacity(0.10))
                .frame(width: 240, height: 240)
                .blur(radius: 66)
                .offset(x: 135, y: 220)
        }
    }
}

struct FloatingModifier: ViewModifier {
    let amount: CGFloat

    func body(content: Content) -> some View {
        content
            .offset(y: -amount * 0.35)
    }
}

extension View {
    func floating(amount: CGFloat = 4) -> some View {
        modifier(FloatingModifier(amount: amount))
    }
}
