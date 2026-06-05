import SwiftUI

struct ProgressHeaderView: View {
    let currentStep: Int
    let title: String
    let subtitle: String

    private let totalSteps = 4

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 13) {
                AnimatedAtomBadge(
                    size: 54,
                    tint: stepTint,
                    symbol: stepIcon,
                    delay: 0.03
                )

                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Step \(currentStep) of \(totalSteps)")
                            .font(.headline)
                            .foregroundStyle(stepTint)

                        Spacer()

                        Text("\(Int(Double(currentStep) / Double(totalSteps) * 100))%")
                            .font(.headline)
                            .foregroundStyle(ChemVaultTheme.secondaryText)
                    }

                    ProgressView(value: Double(currentStep), total: Double(totalSteps))
                        .tint(stepTint)
                        .scaleEffect(x: 1, y: 1.6, anchor: .center)
                }
            }

            Text(title)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(ChemVaultTheme.text)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(ChemVaultTheme.secondaryText)
        }
        .scanSweep(active: true, tint: stepTint, cornerRadius: 24)
    }

    private var stepIcon: String {
        switch currentStep {
        case 1:
            return "shield.lefthalf.filled"
        case 2:
            return "atom"
        case 3:
            return "chart.xyaxis.line"
        default:
            return "doc.text.magnifyingglass"
        }
    }

    private var stepTint: Color {
        switch currentStep {
        case 1:
            return ChemVaultTheme.accent
        case 2:
            return ChemVaultTheme.softAccent
        case 3:
            return ChemVaultTheme.success
        default:
            return ChemVaultTheme.accent
        }
    }
}
