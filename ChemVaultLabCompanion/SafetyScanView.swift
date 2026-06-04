import SwiftUI

struct SafetyScanView: View {
    let onComplete: (SafetyDiagnosis) -> Void

    @State private var selectedRiskIDs = Set<String>()
    @State private var showFeedback = false

    private let cards = [
        SafetyCard(
            icon: "drop.triangle",
            title: "Water sensitivity",
            description: "Grignard reagents react quickly with water. Moisture can destroy the carbon-magnesium bond."
        ),
        SafetyCard(
            icon: "flame",
            title: "Flammable solvents",
            description: "Ether solvents such as diethyl ether and THF are useful, but they must be handled away from flames."
        ),
        SafetyCard(
            icon: "testtube.2",
            title: "Dry glassware",
            description: "Even small amounts of water can lower the yield or stop the reaction completely."
        ),
        SafetyCard(
            icon: "checkmark.seal",
            title: "Acid workup",
            description: "The alkoxide intermediate is protonated during workup to form the final alcohol."
        )
    ]

    private let riskFactors = [
        SafetyRiskFactor(
            id: "moisture",
            icon: "drop.triangle",
            title: "Wet glassware",
            description: "Water protonates the carbon attached to magnesium and destroys the reagent.",
            isCritical: true
        ),
        SafetyRiskFactor(
            id: "flame",
            icon: "flame",
            title: "Open flame near ether",
            description: "Ether solvents are flammable and must be handled away from ignition sources.",
            isCritical: false
        ),
        SafetyRiskFactor(
            id: "fast-quench",
            icon: "exclamationmark.triangle",
            title: "Uncontrolled acid quench",
            description: "Leftover organomagnesium reagent can react vigorously with proton sources.",
            isCritical: false
        ),
        SafetyRiskFactor(
            id: "wrong-intermediate",
            icon: "pencil.and.outline",
            title: "Drawing alcohol too early",
            description: "The reaction forms a magnesium alkoxide before acid workup.",
            isCritical: false
        )
    ]

    private var identifiedMoistureRisk: Bool {
        selectedRiskIDs.contains("moisture")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                ProgressHeaderView(
                    currentStep: 1,
                    title: "Safety Scan",
                    subtitle: "Inspect the case file before entering the Grignard mechanism."
                )
                .smoothAppear(delay: 0.04)

                caseBrief
                    .smoothAppear(delay: 0.10)

                VStack(spacing: 14) {
                    ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                        SafetyCardView(card: card)
                            .smoothAppear(delay: 0.14 + Double(index) * 0.06)
                    }
                }

                riskDiagnosisPanel
                    .padding(.top, 8)
                    .smoothAppear(delay: 0.40)
            }
            .padding(24)
        }
    }

    private var caseBrief: some View {
        PremiumGlassPanel(cornerRadius: 26) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label("Case clue", systemImage: "folder.badge.questionmark")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()

                    Text("Pre-lab")
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(ChemVaultTheme.accent)
                        .clipShape(Capsule())
                }

                Text("The target reaction should form tert-butanol, but the isolated yield is lower than expected. Identify the condition most likely to destroy the Grignard reagent before it reacts.")
                    .font(.subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var riskDiagnosisPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Risk Diagnosis")
                .font(.title2.bold())
                .foregroundStyle(ChemVaultTheme.text)

            Text("Select the risk factors you would flag before allowing the reaction to begin.")
                .font(.subheadline)
                .foregroundStyle(ChemVaultTheme.secondaryText)

            VStack(spacing: 10) {
                ForEach(riskFactors) { factor in
                    SafetyRiskFactorCard(
                        factor: factor,
                        isSelected: selectedRiskIDs.contains(factor.id),
                        revealed: showFeedback
                    ) {
                        toggleRisk(factor.id)
                    }
                }
            }

            if showFeedback {
                safetyFeedback
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            Button {
                if showFeedback {
                    onComplete(
                        SafetyDiagnosis(
                            selectedRiskIDs: selectedRiskIDs,
                            identifiedMoistureRisk: identifiedMoistureRisk
                        )
                    )
                } else {
                    withAnimation(AppMotion.smooth) {
                        showFeedback = true
                    }
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: showFeedback ? "arrow.right" : "checkmark")
                    Text(showFeedback ? "Continue to Mechanism" : "Submit Diagnosis")
                }
                .font(.headline)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(ChemVaultTheme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
        }
        .padding()
        .background(ChemVaultTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var safetyFeedback: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: identifiedMoistureRisk ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundStyle(identifiedMoistureRisk ? ChemVaultTheme.success : ChemVaultTheme.warning)

            VStack(alignment: .leading, spacing: 6) {
                Text(identifiedMoistureRisk ? "Critical finding confirmed" : "Critical moisture risk missed")
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.text)

                Text(identifiedMoistureRisk ? "Correct. Water protonates the Grignard reagent and removes its nucleophilic character before carbonyl attack." : "The strongest diagnosis is wet glassware. Water destroys the polar C-Mg bond, so the reagent is lost before it can add to acetone.")
                    .font(.subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(12)
        .background((identifiedMoistureRisk ? ChemVaultTheme.success : ChemVaultTheme.warning).opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke((identifiedMoistureRisk ? ChemVaultTheme.success : ChemVaultTheme.warning).opacity(0.25), lineWidth: 1)
        )
    }

    private func toggleRisk(_ id: String) {
        guard !showFeedback else { return }

        withAnimation(.spring(response: 0.40, dampingFraction: 0.82)) {
            if selectedRiskIDs.contains(id) {
                selectedRiskIDs.remove(id)
            } else {
                selectedRiskIDs.insert(id)
            }
        }
    }
}

struct SafetyRiskFactor: Identifiable {
    let id: String
    let icon: String
    let title: String
    let description: String
    let isCritical: Bool
}

struct SafetyRiskFactorCard: View {
    let factor: SafetyRiskFactor
    let isSelected: Bool
    let revealed: Bool
    let action: () -> Void

    private var borderColor: Color {
        if revealed && factor.isCritical {
            return ChemVaultTheme.success.opacity(0.45)
        }

        return isSelected ? ChemVaultTheme.accent.opacity(0.42) : .white.opacity(0.07)
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .top, spacing: 13) {
                ZStack {
                    Circle()
                        .fill(isSelected ? ChemVaultTheme.accent : .white.opacity(0.09))
                        .frame(width: 38, height: 38)

                    Image(systemName: factor.icon)
                        .foregroundStyle(isSelected ? .black : ChemVaultTheme.accent)
                }

                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 8) {
                        Text(factor.title)
                            .font(.headline)
                            .foregroundStyle(ChemVaultTheme.text)

                        if revealed && factor.isCritical {
                            Text("critical")
                                .font(.caption2.bold())
                                .foregroundStyle(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(ChemVaultTheme.success)
                                .clipShape(Capsule())
                        }
                    }

                    Text(factor.description)
                        .font(.caption)
                        .foregroundStyle(ChemVaultTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? ChemVaultTheme.accent : ChemVaultTheme.tertiaryText)
            }
            .padding(13)
            .background(isSelected ? ChemVaultTheme.accent.opacity(0.10) : .white.opacity(0.045))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .pressableFeedback()
    }
}

struct SafetyCardView: View {
    let card: SafetyCard

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: card.icon)
                .font(.title2)
                .foregroundStyle(ChemVaultTheme.accent)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 6) {
                Text(card.title)
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.text)

                Text(card.description)
                    .font(.subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
            }

            Spacer()
        }
        .padding()
        .background(ChemVaultTheme.card)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
