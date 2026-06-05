import SwiftUI

struct LabNotebookSummaryView: View {
    let caseFile: LabCaseFile
    let onRestart: () -> Void

    @State private var appear = false
    @State private var selectedSection: NotebookSection = .mechanism

    var body: some View {
        GeometryReader { geometry in
            let compact = geometry.size.width < 430

            ZStack {
                ScrollView {
                    VStack(spacing: compact ? 16 : 22) {
                        completionHero(compact: compact)
                            .smoothAppear(delay: 0.04)

                        MentorGradeView(caseFile: caseFile, compact: compact)
                            .smoothAppear(delay: 0.10)

                        achievementGrid(compact: compact)
                            .smoothAppear(delay: 0.16)

                        caseReport(compact: compact)
                            .smoothAppear(delay: 0.22)

                        evidenceTimeline(compact: compact)
                            .smoothAppear(delay: 0.28)

                        notebookTabs(compact: compact)
                            .smoothAppear(delay: 0.34)

                        notebookContent(compact: compact)
                            .smoothAppear(delay: 0.40)

                        generatedConclusion(compact: compact)
                            .smoothAppear(delay: 0.46)

                        blockersPanel(compact: compact)
                            .smoothAppear(delay: 0.52)

                        labReadinessCard(compact: compact)
                            .smoothAppear(delay: 0.58)

                        Spacer(minLength: 110)
                    }
                    .padding(.horizontal, compact ? 14 : 24)
                    .padding(.top, compact ? 16 : 28)
                    .frame(maxWidth: 900)
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

    private func completionHero(compact: Bool) -> some View {
        let tint = caseFile.readiness.tint

        return PremiumGlassPanel(cornerRadius: compact ? 26 : 36) {
            VStack(spacing: compact ? 16 : 22) {
                AnimatedAtomBadge(
                    size: compact ? 112 : 148,
                    tint: tint,
                    symbol: caseFile.readiness.icon,
                    delay: 0.05
                )

                VStack(spacing: 8) {
                    Text(caseFile.conclusionTitle)
                        .font(.system(size: compact ? 30 : 44, weight: .bold, design: .rounded))
                        .foregroundStyle(ChemVaultTheme.text)
                        .multilineTextAlignment(.center)

                    Text(caseFile.mentorNote)
                        .font(compact ? .subheadline : .title3)
                        .foregroundStyle(ChemVaultTheme.secondaryText)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    DiagnosticSeal(
                        title: caseFile.readiness.statusText,
                        icon: caseFile.readiness.icon,
                        tint: tint,
                        delay: 0.18
                    )
                }
            }
        }
        .scanSweep(active: true, tint: tint, cornerRadius: compact ? 26 : 36)
    }

    private func achievementGrid(compact: Bool) -> some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 12
        ) {
            NotebookAchievementCard(
                icon: "drop.triangle.fill",
                title: "Safety",
                value: caseFile.safetyDiagnosis.identifiedMoistureRisk ? "Moisture found" : "Review dryness",
                tint: ChemVaultTheme.accent
            )

            NotebookAchievementCard(
                icon: "arrow.triangle.branch",
                title: "Mechanism",
                value: caseFile.challengeResult.scoreText,
                tint: ChemVaultTheme.softAccent
            )

            NotebookAchievementCard(
                icon: "minus.circle.fill",
                title: "Intermediate",
                value: "Mg alkoxide",
                tint: .red.opacity(0.9)
            )

            NotebookAchievementCard(
                icon: "chart.bar.xaxis",
                title: "Data",
                value: caseFile.yieldRecord.diagnosis.title,
                tint: ChemVaultTheme.success
            )
        }
    }

    private func caseReport(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 24 : 30) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Generated Case Report", systemImage: "doc.text.magnifyingglass")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()

                    Text(caseFile.readiness.statusText)
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(caseFile.readiness.tint)
                        .clipShape(Capsule())
                }

                VStack(spacing: 10) {
                    NotebookCaseReportCard(
                        icon: "shield.lefthalf.filled",
                        title: "Safety finding",
                        value: caseFile.safetySummary,
                        tint: ChemVaultTheme.accent
                    )

                    NotebookCaseReportCard(
                        icon: "arrow.triangle.branch",
                        title: "Mechanism check",
                        value: "Challenge score: \(caseFile.challengeResult.scoreText)",
                        tint: ChemVaultTheme.softAccent
                    )

                    NotebookCaseReportCard(
                        icon: "brain.head.profile",
                        title: "Misconception diagnosis",
                        value: caseFile.challengeResult.misconceptionSummary,
                        tint: caseFile.challengeResult.misconceptions.isEmpty ? ChemVaultTheme.success : ChemVaultTheme.warning
                    )

                    NotebookCaseReportCard(
                        icon: "chart.xyaxis.line",
                        title: "Yield diagnosis",
                        value: caseFile.yieldSummary,
                        tint: caseFile.yieldRecord.diagnosis.tint
                    )
                }
            }
        }
    }

    private func evidenceTimeline(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 24 : 30) {
            CaseTimelineView(items: caseFile.evidenceItems, compact: compact)
        }
    }

    private func notebookTabs(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 22 : 28) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Notebook Sections")
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.text)

                HStack(spacing: 8) {
                    ForEach(NotebookSection.allCases, id: \.self) { section in
                        Button {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                                selectedSection = section
                            }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: section.icon)
                                    .font(.headline)

                                Text(section.title)
                                    .font(.caption2.bold())
                            }
                            .foregroundStyle(selectedSection == section ? .black : ChemVaultTheme.text)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(selectedSection == section ? ChemVaultTheme.accent : .white.opacity(0.055))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .scanSweep(active: selectedSection == section, tint: ChemVaultTheme.accent, cornerRadius: 16)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func notebookContent(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 24 : 30) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: selectedSection.icon)
                        .foregroundStyle(ChemVaultTheme.accent)

                    Text(selectedSection.heading)
                        .font(.title3.bold())
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()
                }

                Text(selectedSection.body)
                    .font(compact ? .subheadline : .body)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()
                    .background(.white.opacity(0.12))

                VStack(alignment: .leading, spacing: 8) {
                    Text("Key takeaways")
                        .font(.caption.bold())
                        .foregroundStyle(ChemVaultTheme.accent)

                    ForEach(selectedSection.takeaways, id: \.self) { takeaway in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(ChemVaultTheme.success)

                            Text(takeaway)
                                .font(.caption)
                                .foregroundStyle(ChemVaultTheme.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .id(selectedSection)
            .transition(.opacity.combined(with: .move(edge: .bottom)))
        }
        .animation(.spring(response: 0.55, dampingFraction: 0.84), value: selectedSection)
    }

    private func generatedConclusion(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 24 : 30) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label("Notebook-Ready Conclusion", systemImage: "doc.text.fill")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()

                    DiagnosticSeal(
                        title: caseFile.mentorGrade.rawValue,
                        icon: "checkmark.seal.fill",
                        tint: caseFile.mentorGrade.tintRole.color
                    )
                }

                Text(caseFile.notebookConclusion)
                    .font(compact ? .subheadline : .body)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func blockersPanel(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 24 : 30) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label(
                        caseFile.unresolvedBlockers.isEmpty ? "Evidence Clear" : "Review Queue",
                        systemImage: caseFile.unresolvedBlockers.isEmpty ? "checkmark.seal.fill" : "exclamationmark.triangle.fill"
                    )
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.text)

                    Spacer()
                }

                if caseFile.unresolvedBlockers.isEmpty {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(ChemVaultTheme.success)

                        Text("No unresolved blockers remain. The report connects safety, mechanism, data, and conclusion into one coherent pre-lab explanation.")
                            .font(.subheadline)
                            .foregroundStyle(ChemVaultTheme.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .background(ChemVaultTheme.success.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                } else {
                    VStack(spacing: 10) {
                        ForEach(caseFile.unresolvedBlockers) { blocker in
                            NotebookBlockerRow(blocker: blocker)
                        }
                    }
                }
            }
        }
    }

    private func labReadinessCard(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 24 : 30) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Lab Readiness", systemImage: "graduationcap.fill")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()

                    Text(caseFile.readiness.statusText)
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(caseFile.readiness.tint)
                        .clipShape(Capsule())
                }

                ReadinessMeter(
                    progress: Double(caseFile.readinessScore) / 100,
                    tint: caseFile.readiness.tint
                )
                    .frame(height: 72)

                Text(caseFile.nextRecommendation)
                    .font(.caption)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func bottomActionBar(compact: Bool) -> some View {
        VStack(spacing: 8) {
            LiquidGlassButton(
                title: "Restart Lab Simulation",
                icon: "arrow.counterclockwise"
            ) {
                onRestart()
            }

            Text("Use this notebook as your pre-lab revision summary.")
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

enum NotebookSection: CaseIterable {
    case safety
    case mechanism
    case data
    case exam

    var title: String {
        switch self {
        case .safety:
            return "Safety"
        case .mechanism:
            return "Mechanism"
        case .data:
            return "Data"
        case .exam:
            return "Exam"
        }
    }

    var icon: String {
        switch self {
        case .safety:
            return "shield.lefthalf.filled"
        case .mechanism:
            return "arrow.triangle.branch"
        case .data:
            return "chart.xyaxis.line"
        case .exam:
            return "pencil.and.list.clipboard"
        }
    }

    var heading: String {
        switch self {
        case .safety:
            return "Safety interpretation"
        case .mechanism:
            return "Mechanistic summary"
        case .data:
            return "Data interpretation"
        case .exam:
            return "Exam-ready explanation"
        }
    }

    var body: String {
        switch self {
        case .safety:
            return "Grignard reagents are highly moisture-sensitive. Water or alcohols protonate the carbon attached to magnesium, destroying the reagent before it can add to the carbonyl compound. Dry glassware and anhydrous solvent are therefore chemically necessary, not just procedural details."
        case .mechanism:
            return "MeMgBr contains a strongly polarised C–Mg bond. The methyl carbon behaves as a nucleophilic site. The carbonyl oxygen can coordinate to MgBr⁺, increasing carbonyl electrophilicity. The methyl group then attacks the carbonyl carbon while the C=O π electrons move to oxygen, forming a magnesium alkoxide. Acid workup protonates the alkoxide to give the alcohol."
        case .data:
            return "A reduced percentage yield may indicate moisture contamination, incomplete addition, product loss during transfer or workup, poor phase separation, or impurity in the isolated product. Yield should be interpreted alongside mechanism and experimental handling."
        case .exam:
            return "In an exam, draw the nucleophilic attack arrow from the methyl carbon toward the carbonyl carbon. Draw the second arrow from the C=O π bond to oxygen. Do not draw the alcohol immediately; show the alkoxide first, then protonation during workup."
        }
    }

    var takeaways: [String] {
        switch self {
        case .safety:
            return [
                "Dry conditions protect the C–Mg bond.",
                "Moisture quenches the Grignard reagent.",
                "Controlled workup prevents vigorous protonation."
            ]
        case .mechanism:
            return [
                "Cδ−–Mgδ+ polarisation creates nucleophilic character.",
                "O→Mg coordination activates the carbonyl.",
                "Alkoxide formation occurs before alcohol formation."
            ]
        case .data:
            return [
                "Yield reflects both chemistry and technique.",
                "Low yield can come from moisture or handling loss.",
                "Mechanism helps explain experimental outcomes."
            ]
        case .exam:
            return [
                "Arrow starts from electron-rich carbon, not Mg.",
                "π(C=O) electrons move to oxygen.",
                "Show acid workup as a separate protonation step."
            ]
        }
    }
}

struct NotebookAchievementCard: View {
    let icon: String
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.16))
                    .frame(width: 42, height: 42)

                Image(systemName: icon)
                    .foregroundStyle(tint)
                    .font(.headline)
            }

            Text(title)
                .font(.headline)
                .foregroundStyle(ChemVaultTheme.text)

            Text(value)
                .font(.caption.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.secondaryText)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(tint.opacity(0.16), lineWidth: 1)
        )
        .scanSweep(active: true, tint: tint, cornerRadius: 22)
    }
}

struct NotebookCaseReportCard: View {
    let icon: String
    let title: String
    let value: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.16))
                    .frame(width: 38, height: 38)

                Image(systemName: icon)
                    .font(.headline)
                    .foregroundStyle(tint)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(ChemVaultTheme.accent)

                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(12)
        .background(.white.opacity(0.045))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(tint.opacity(0.16), lineWidth: 1)
        )
        .scanSweep(active: true, tint: tint, cornerRadius: 18)
    }
}

struct NotebookBlockerRow: View {
    let blocker: CaseBlocker

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(ChemVaultTheme.warning.opacity(0.16))
                    .frame(width: 38, height: 38)

                Image(systemName: blocker.icon)
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.warning)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(blocker.title)
                    .font(.caption.bold())
                    .foregroundStyle(ChemVaultTheme.warning)

                Text(blocker.detail)
                    .font(.subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(12)
        .background(ChemVaultTheme.warning.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(ChemVaultTheme.warning.opacity(0.18), lineWidth: 1)
        )
        .scanSweep(active: true, tint: ChemVaultTheme.warning, cornerRadius: 18)
    }
}

struct ReadinessMeter: View {
    let targetProgress: Double
    let tint: Color

    @State private var animatedProgress: CGFloat = 0

    init(progress: Double, tint: Color) {
        self.targetProgress = max(0, min(1, progress))
        self.tint = tint
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.08))
                        .frame(height: 10)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    ChemVaultTheme.accent,
                                    ChemVaultTheme.softAccent,
                                    tint
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: proxy.size.width * animatedProgress, height: 10)

                    Circle()
                        .fill(tint)
                        .frame(width: 20, height: 20)
                        .offset(x: max(0, proxy.size.width * animatedProgress - 10))
                        .shadow(color: tint.opacity(0.6), radius: 10)
                }
            }
            .frame(height: 22)

            HStack {
                Text("Unprepared")
                Spacer()
                Text("Lab-ready")
            }
            .font(.caption2.weight(.semibold))
            .foregroundStyle(ChemVaultTheme.tertiaryText)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).delay(0.25)) {
                animatedProgress = targetProgress
            }
        }
        .onChange(of: targetProgress) { _, newValue in
            withAnimation(.easeInOut(duration: 0.8)) {
                animatedProgress = CGFloat(newValue)
            }
        }
    }
}
