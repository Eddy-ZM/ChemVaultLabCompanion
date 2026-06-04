import SwiftUI

struct LabMissionView: View {
    let caseFile: LabCaseFile
    let onBegin: () -> Void

    @State private var appear = false
    @State private var selectedMissionIndex: Int? = nil

    private let missions = [
        LabMissionItem(
            icon: "drop.triangle",
            title: "Find the reagent killer",
            subtitle: "Diagnose why dry glassware matters.",
            detail: "Water protonates and destroys the polarised C–Mg bond before it can react with the carbonyl."
        ),
        LabMissionItem(
            icon: "plusminus",
            title: "Locate the nucleophilic carbon",
            subtitle: "Track Cδ−–Mgδ+ polarisation.",
            detail: "The carbon attached to magnesium behaves as the nucleophilic site in the reaction."
        ),
        LabMissionItem(
            icon: "link",
            title: "Prove carbonyl activation",
            subtitle: "Recognise O→Mg coordination.",
            detail: "Magnesium acts as a Lewis acid and helps make the carbonyl carbon more electrophilic."
        ),
        LabMissionItem(
            icon: "arrow.triangle.branch",
            title: "Track the bond-forming arrows",
            subtitle: "Connect curved arrows to real bond changes.",
            detail: "The methyl group attacks the carbonyl carbon while the C=O π electrons move onto oxygen."
        ),
        LabMissionItem(
            icon: "chart.bar.xaxis",
            title: "Diagnose the yield",
            subtitle: "Use yield as chemical evidence.",
            detail: "The final yield can reveal moisture, incomplete reaction, transfer loss, or product impurity."
        )
    ]

    var body: some View {
        GeometryReader { geometry in
            let compact = geometry.size.width < 430

            ZStack {
                ScrollView {
                    VStack(spacing: compact ? 18 : 26) {
                        missionHero(compact: compact)
                            .smoothAppear(delay: 0.04)

                        EvidenceLedgerView(caseFile: caseFile, compact: compact)
                            .smoothAppear(delay: 0.10)

                        missionBriefing(compact: compact)
                            .smoothAppear(delay: 0.18)

                        missionChecklist(compact: compact)
                            .smoothAppear(delay: 0.30)

                        simulationPreview(compact: compact)
                            .smoothAppear(delay: 0.42)

                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, compact ? 16 : 24)
                    .padding(.top, compact ? 18 : 34)
                    .frame(maxWidth: 860)
                    .frame(maxWidth: .infinity)
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomActionBar(compact: compact)
            }
            .onAppear {
                withAnimation(.spring(response: 0.75, dampingFraction: 0.86)) {
                    appear = true
                }

            }
        }
    }

    private func missionHero(compact: Bool) -> some View {
        VStack(spacing: compact ? 16 : 22) {
            ZStack {
                Circle()
                    .fill(ChemVaultTheme.accent.opacity(0.16))
                    .frame(width: compact ? 108 : 138, height: compact ? 108 : 138)
                    .blur(radius: 3)

                Circle()
                    .stroke(ChemVaultTheme.accent.opacity(0.28), lineWidth: 1)
                    .frame(width: compact ? 124 : 158, height: compact ? 124 : 158)

                Image(systemName: "flask.fill")
                    .font(.system(size: compact ? 52 : 70, weight: .semibold))
                    .foregroundStyle(ChemVaultTheme.accent)
            }

            VStack(spacing: 8) {
                Text("Case 04")
                    .font(.system(size: compact ? 34 : 48, weight: .bold, design: .rounded))
                    .foregroundStyle(ChemVaultTheme.text)

                Text("The Vanishing Grignard Yield")
                    .font(.system(size: compact ? 21 : 28, weight: .semibold, design: .rounded))
                    .foregroundStyle(ChemVaultTheme.softAccent)

                Text("A tert-butanol synthesis produced a suspicious yield. Inspect the safety conditions, prove the mechanism, and decide what the data really means.")
                    .font(compact ? .subheadline : .title3)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, compact ? 4 : 32)
            }
        }
    }

    private func missionBriefing(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 26 : 34) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Case Reaction", systemImage: "folder.badge.questionmark")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()

                        Text("Case file")
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(ChemVaultTheme.accent)
                        .clipShape(Capsule())
                }

                reactionEquation(compact: compact)

                Text("Your goal is to build an evidence chain before writing the notebook: identify the reagent killer, prove the electron flow, avoid the premature alcohol misconception, then decide whether the yield can be trusted.")
                    .font(compact ? .subheadline : .body)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func reactionEquation(compact: Bool) -> some View {
        HStack(spacing: compact ? 8 : 14) {
            formulaChip("(CH₃)₂C=O")

            Text("+")
                .font(.title3.bold())
                .foregroundStyle(ChemVaultTheme.secondaryText)

            formulaChip("CH₃MgBr")

            Text("→")
                .font(.title3.bold())
                .foregroundStyle(ChemVaultTheme.accent)

            formulaChip("(CH₃)₃C–OH")
        }
        .font(compact ? .caption.bold() : .subheadline.bold())
        .minimumScaleFactor(0.65)
    }

    private func formulaChip(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(ChemVaultTheme.text)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(.white.opacity(0.065))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(.white.opacity(0.08), lineWidth: 1)
            )
    }

    private func missionChecklist(compact: Bool) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Mission Objectives")
                .font(.title3.bold())
                .foregroundStyle(ChemVaultTheme.text)

            VStack(spacing: 12) {
                ForEach(Array(missions.enumerated()), id: \.element.id) { index, mission in
                    MissionObjectiveCard(
                        item: mission,
                        index: index + 1,
                        isSelected: selectedMissionIndex == index
                    ) {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                            selectedMissionIndex = selectedMissionIndex == index ? nil : index
                        }
                    }
                    .smoothAppear(delay: 0.34 + Double(index) * 0.05)
                }
            }
        }
    }

    private func simulationPreview(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 26 : 34) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Simulation Path", systemImage: "sparkles")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()
                }

                HStack(spacing: 0) {
                    SimulationStepDot(number: 1, title: "Safety", active: true)
                    SimulationConnector()
                    SimulationStepDot(number: 2, title: "Mechanism", active: true)
                    SimulationConnector()
                    SimulationStepDot(number: 3, title: "Data", active: true)
                    SimulationConnector()
                    SimulationStepDot(number: 4, title: "Notebook", active: false)
                }

                Text("You will first check lab risks, then enter Mechanism Cinema, then interpret yield and generate a final notebook summary.")
                    .font(.caption)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func bottomActionBar(compact: Bool) -> some View {
        VStack(spacing: 8) {
            LiquidGlassButton(
                title: "Begin Lab Simulation",
                icon: "play.fill"
            ) {
                onBegin()
            }

            Text("Start with safety, then reveal the molecular mechanism.")
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
                                    ChemVaultTheme.background.opacity(0.72)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
                .ignoresSafeArea()
        )
    }
}

struct LabMissionItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let detail: String
}

struct MissionObjectiveCard: View {
    let item: LabMissionItem
    let index: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(isSelected ? ChemVaultTheme.accent : .white.opacity(0.09))
                            .frame(width: 38, height: 38)

                        Text("\(index)")
                            .font(.caption.bold())
                            .foregroundStyle(isSelected ? .black : ChemVaultTheme.text)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: item.icon)
                                .foregroundStyle(ChemVaultTheme.accent)

                            Text(item.title)
                                .font(.headline)
                                .foregroundStyle(ChemVaultTheme.text)
                        }

                        Text(item.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(ChemVaultTheme.secondaryText)
                    }

                    Spacer()

                    Image(systemName: isSelected ? "chevron.up" : "chevron.down")
                        .font(.caption.bold())
                        .foregroundStyle(ChemVaultTheme.tertiaryText)
                }

                if isSelected {
                    Text(item.detail)
                        .font(.caption)
                        .foregroundStyle(ChemVaultTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 50)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding()
            .background(isSelected ? ChemVaultTheme.accent.opacity(0.10) : .white.opacity(0.045))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(isSelected ? ChemVaultTheme.accent.opacity(0.35) : .white.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .pressableFeedback()
    }
}

struct SimulationStepDot: View {
    let number: Int
    let title: String
    let active: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(active ? ChemVaultTheme.accent : .white.opacity(0.10))
                    .frame(width: 30, height: 30)

                Text("\(number)")
                    .font(.caption.bold())
                    .foregroundStyle(active ? .black : ChemVaultTheme.secondaryText)
            }

            Text(title)
                .font(.caption2.bold())
                .foregroundStyle(active ? ChemVaultTheme.text : ChemVaultTheme.tertiaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SimulationConnector: View {
    var body: some View {
        Rectangle()
            .fill(ChemVaultTheme.accent.opacity(0.35))
            .frame(height: 3)
            .frame(maxWidth: 30)
            .offset(y: -12)
    }
}
