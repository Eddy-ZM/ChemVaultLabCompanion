import SwiftUI

struct MechanismExplorerView: View {
    let onComplete: () -> Void

    @State private var stepIndex = 0
    @State private var animationTrigger = 0
    @State private var focusMode: FocusMode = .mechanism

    private var currentCinemaStep: CinemaStep {
        CinemaStep(rawValue: min(max(stepIndex, 0), 5)) ?? .electronicPreparation
    }

    var body: some View {
        GeometryReader { geometry in
            let compact = geometry.size.width < 430
            let horizontalPadding: CGFloat = compact ? 14 : 24
            let cinemaHeight: CGFloat = compact ? 360 : 500

            ZStack {
                ScrollView {
                    VStack(spacing: compact ? 14 : 20) {
                        header(compact: compact)
                            .smoothAppear(delay: 0.04)

                        MechanismChapterStrip(currentStep: currentCinemaStep)
                            .smoothAppear(delay: 0.10)

                        MechanismEvidenceStrip(step: currentCinemaStep)
                            .smoothAppear(delay: 0.13)

                        PremiumGlassPanel(cornerRadius: compact ? 24 : 34) {
                            VStack(spacing: 12) {
                                topBar(compact: compact)

                                MechanismCinemaCanvas(
                                    step: currentCinemaStep,
                                    focusMode: focusMode,
                                    animationTrigger: animationTrigger
                                )
                                .frame(height: cinemaHeight)
                                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .stroke(.white.opacity(0.08), lineWidth: 1)
                                )
                            }
                        }
                        .smoothAppear(delay: 0.16)

                        MechanismStoryPanel(step: currentCinemaStep)
                            .smoothAppear(delay: 0.24)

                        MechanismFocusPanel(
                            step: currentCinemaStep,
                            focusMode: focusMode
                        ) { selected in
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                                focusMode = selected
                            }
                        }
                        .smoothAppear(delay: 0.32)

                        AcademicEnergyProfileView(stepIndex: min(stepIndex, 4))
                            .smoothAppear(delay: 0.40)
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, compact ? 12 : 24)
                    .padding(.bottom, 118)
                    .frame(maxWidth: 900)
                    .frame(maxWidth: .infinity)
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomActionBar(compact: compact)
            }
        }
    }

    private func header(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 24 : 34) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(ChemVaultTheme.accent.opacity(0.16))
                        .frame(width: compact ? 44 : 62, height: compact ? 44 : 62)

                    Image(systemName: "atom")
                        .font(.system(size: compact ? 23 : 32, weight: .semibold))
                        .foregroundStyle(ChemVaultTheme.accent)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Mechanism Cinema")
                        .font(.system(size: compact ? 21 : 30, weight: .bold, design: .rounded))
                        .foregroundStyle(ChemVaultTheme.text)

                    Text("A story-driven academic visualisation of Grignard addition.")
                        .font(compact ? .caption : .subheadline)
                        .foregroundStyle(ChemVaultTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
        }
    }

    private func topBar(compact: Bool) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(currentCinemaStep.title)
                    .font(compact ? .subheadline.bold() : .headline)
                    .foregroundStyle(ChemVaultTheme.text)

                Text(currentCinemaStep.keyFormula)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
            }

            Spacer()

            Text("Scene \(stepIndex + 1)/6")
                .font(.caption.weight(.bold))
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(ChemVaultTheme.accent)
                .clipShape(Capsule())
        }
    }

    private func bottomActionBar(compact: Bool) -> some View {
        VStack(spacing: 8) {
            LiquidGlassButton(
                title: buttonTitle,
                icon: buttonIcon
            ) {
                nextStep()
            }

            Text(bottomHint)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.tertiaryText)
        }
        .padding(.horizontal, compact ? 14 : 24)
        .padding(.top, 10)
        .padding(.bottom, compact ? 8 : 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    ChemVaultTheme.background.opacity(0.10),
                                    ChemVaultTheme.background.opacity(0.70)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
                .ignoresSafeArea()
        )
    }

    private var buttonTitle: String {
        if stepIndex < 5 {
            return currentCinemaStep.story.nextAction
        } else {
            return "Continue to Mechanism Challenge"
        }
    }

    private var bottomHint: String {
        if stepIndex < 5 {
            return currentCinemaStep.story.nextAction
        }

        return "Test your mechanism reasoning before data diagnosis."
    }

    private var buttonIcon: String {
        stepIndex < 5 ? "arrow.right" : "checkmark"
    }

    private func nextStep() {
        if stepIndex < 5 {
            let newIndex = stepIndex + 1

            withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                stepIndex = newIndex
                focusMode = suggestedFocusMode(for: newIndex)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                animationTrigger += 1
            }
        } else {
            onComplete()
        }
    }

    private func suggestedFocusMode(for index: Int) -> FocusMode {
        switch index {
        case 0:
            return .charges          // electronic preparation
        case 1:
            return .mechanism        // O→Mg coordination arrow
        case 2:
            return .orbitals         // HOMO→LUMO alignment
        case 3:
            return .mechanism        // curved arrows and electron flow
        case 4:
            return .charges          // O⁻···MgBr⁺
        case 5:
            return .mechanism        // protonation
        default:
            return .mechanism
        }
    }
}

#Preview {
    MechanismExplorerView {
        print("Complete")
    }
}
