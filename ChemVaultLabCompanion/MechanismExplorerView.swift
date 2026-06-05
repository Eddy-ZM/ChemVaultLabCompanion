import SwiftUI

struct MechanismExplorerView: View {
    let caseFile: LabCaseFile
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

                        EvidenceLedgerView(caseFile: caseFile, compact: compact)
                            .smoothAppear(delay: 0.08)

                        MechanismChapterStrip(currentStep: currentCinemaStep)
                            .smoothAppear(delay: 0.12)

                        MechanismEvidenceStrip(step: currentCinemaStep)
                            .smoothAppear(delay: 0.15)

                        MechanismProofCard(step: currentCinemaStep, compact: compact)
                            .smoothAppear(delay: 0.18)

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
                        .smoothAppear(delay: 0.22)

                        MechanismStoryPanel(step: currentCinemaStep)
                        .smoothAppear(delay: 0.30)

                        MechanismFocusPanel(
                            step: currentCinemaStep,
                            focusMode: focusMode
                        ) { selected in
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                                focusMode = selected
                            }
                        }
                        .smoothAppear(delay: 0.38)

                        AcademicEnergyProfileView(stepIndex: min(stepIndex, 4))
                        .smoothAppear(delay: 0.46)
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
                AnimatedAtomBadge(size: compact ? 52 : 68, tint: ChemVaultTheme.accent, delay: 0.04)

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
        .scanSweep(active: true, tint: ChemVaultTheme.accent, cornerRadius: compact ? 24 : 34)
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

private struct MechanismProofCard: View {
    let step: CinemaStep
    let compact: Bool

    private var proof: MechanismProof {
        step.mechanismProof
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(ChemVaultTheme.softAccent.opacity(0.18))
                    .frame(width: compact ? 42 : 50, height: compact ? 42 : 50)

                Image(systemName: proof.icon)
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.softAccent)
            }

            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 8) {
                    Text("Proof Card")
                        .font(.caption.bold())
                        .foregroundStyle(ChemVaultTheme.softAccent)

                    Text(step.story.chapter)
                        .font(.caption2.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ChemVaultTheme.softAccent)
                        .clipShape(Capsule())
                }

                Text(proof.title)
                    .font(compact ? .headline : .title3.bold())
                    .foregroundStyle(ChemVaultTheme.text)

                Text(proof.detail)
                    .font(.subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Notebook use: \(step.story.whyItMatters)")
                    .font(.caption)
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
                    .fixedSize(horizontal: false, vertical: true)

                ProofUnlockBanner(
                    title: "Mechanism proof unlocked",
                    detail: proof.title,
                    icon: proof.icon,
                    tint: ChemVaultTheme.softAccent,
                    trigger: step.rawValue
                )
                .padding(.top, 2)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(ChemVaultTheme.softAccent.opacity(0.16), lineWidth: 1)
        )
        .scanSweep(active: true, tint: ChemVaultTheme.softAccent, cornerRadius: 22)
        .animation(.spring(response: 0.55, dampingFraction: 0.84), value: step.rawValue)
    }
}

private extension CinemaStep {
    var mechanismProof: MechanismProof {
        switch self {
        case .electronicPreparation:
            return .polarity
        case .lewisAcidActivation:
            return .coordination
        case .orbitalAlignment:
            return .orbitalAlignment
        case .electronMovement:
            return .electronFlow
        case .magnesiumAlkoxide:
            return .alkoxide
        case .acidicWorkup:
            return .workup
        }
    }
}

#Preview {
    MechanismExplorerView(caseFile: .sampleReady) {
        print("Complete")
    }
}
