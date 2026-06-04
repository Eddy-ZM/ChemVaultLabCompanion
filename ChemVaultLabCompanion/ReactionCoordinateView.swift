import SwiftUI

struct ReactionCoordinateView: View {
    let step: Int

    private var progress: CGFloat {
        switch step {
        case 0: return 0.18
        case 1: return 0.62
        default: return 1.0
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reaction Coordinate")
                .font(.caption.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.tertiaryText)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.08))
                        .frame(height: 8)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    ChemVaultTheme.accent,
                                    ChemVaultTheme.softAccent
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)

                    Circle()
                        .fill(ChemVaultTheme.accent)
                        .frame(width: 18, height: 18)
                        .offset(x: max(0, geometry.size.width * progress - 9))
                        .shadow(color: ChemVaultTheme.accent.opacity(0.55), radius: 8)
                }
            }
            .frame(height: 20)

            HStack {
                Text("Reactants")
                Spacer()
                Text("Intermediate")
                Spacer()
                Text("Product")
            }
            .font(.caption2)
            .foregroundStyle(ChemVaultTheme.tertiaryText)
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.84), value: step)
    }
}
