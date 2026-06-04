import SwiftUI

struct AcademicMechanismNoteView: View {
    let stepIndex: Int

    private var step: AcademicMechanismStep {
        AcademicMechanismStep(rawValue: min(max(stepIndex, 0), 4)) ?? .polarisation
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(ChemVaultTheme.accent)

                Text("Academic Note")
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.text)

                Spacer()
            }

            Text(note)
                .font(.subheadline)
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            Divider()
                .background(.white.opacity(0.15))

            HStack(alignment: .top, spacing: 10) {
                Text("Key idea")
                    .font(.caption.bold())
                    .foregroundStyle(ChemVaultTheme.accent)

                Text(keyIdea)
                    .font(.caption)
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }

    private var icon: String {
        switch step {
        case .polarisation:
            return "bolt.fill"
        case .coordination:
            return "link"
        case .addition:
            return "arrow.triangle.branch"
        case .alkoxide:
            return "minus.circle.fill"
        case .workup:
            return "drop.fill"
        }
    }

    private var note: String {
        switch step {
        case .polarisation:
            return "A Grignard reagent is not a free carbanion, but the carbon attached to magnesium is strongly nucleophilic because the C–Mg bond is polarised toward carbon."
        case .coordination:
            return "The carbonyl oxygen can coordinate to magnesium. This Lewis acid interaction makes the carbonyl carbon more electrophilic and organises the reacting partners."
        case .addition:
            return "The methyl group attacks the carbonyl carbon. Simultaneously, the π electrons of the C=O bond move onto oxygen, avoiding violation of the octet rule."
        case .alkoxide:
            return "The immediate product is not the alcohol. It is a magnesium alkoxide, often represented as R₃C–O⁻ MgBr⁺."
        case .workup:
            return "Acidic workup protonates the alkoxide oxygen, converting the charged intermediate into the neutral tertiary alcohol."
        }
    }

    private var keyIdea: String {
        switch step {
        case .polarisation:
            return "Nucleophilicity comes from Cδ−–Mgδ+ polarisation."
        case .coordination:
            return "MgBr⁺ behaves as a Lewis acid toward the carbonyl oxygen."
        case .addition:
            return "C–C bond formation and π-bond cleavage occur together."
        case .alkoxide:
            return "The intermediate is tetrahedral and negatively charged at oxygen."
        case .workup:
            return "The final alcohol appears only after protonation."
        }
    }
}
