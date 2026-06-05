import SwiftUI

struct DataCheckView: View {
    let caseFile: LabCaseFile
    let onComplete: (YieldRecord) -> Void

    @State private var actualMass = "0.548"
    @State private var theoreticalMass = "0.800"

    private var yieldValue: Double? {
        guard let actual = Double(actualMass),
              let theoretical = Double(theoreticalMass),
              theoretical > 0 else {
            return nil
        }

        return actual / theoretical * 100
    }

    var body: some View {
        GeometryReader { geometry in
            let compact = geometry.size.width < 430

            ScrollView {
                VStack(spacing: compact ? 18 : 24) {
                    ProgressHeaderView(
                        currentStep: 3,
                        title: "Data Check",
                        subtitle: "Connect mass measurements to experimental quality."
                    )
                    .smoothAppear(delay: 0.04)

                    EvidenceLedgerView(caseFile: liveCaseFile, compact: compact)
                        .smoothAppear(delay: 0.10)

                    inputCard
                        .smoothAppear(delay: 0.16)

                    yieldCard
                        .smoothAppear(delay: 0.28)

                    interpretationCard
                        .smoothAppear(delay: 0.40)

                    yieldBandCard
                        .smoothAppear(delay: 0.43)

                    diagnosisCard
                        .smoothAppear(delay: 0.46)

                    PrimaryButton("Complete Lab", icon: "checkmark") {
                        onComplete(
                            YieldRecord(
                                percent: yieldValue,
                                diagnosis: yieldDiagnosis
                            )
                        )
                    }
                    .smoothAppear(delay: 0.52)
                }
                .padding(compact ? 16 : 24)
                .frame(maxWidth: 760)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var liveCaseFile: LabCaseFile {
        var updated = caseFile
        updated.yieldRecord = YieldRecord(percent: yieldValue, diagnosis: yieldDiagnosis)
        return updated
    }

    private var inputCard: some View {
        ChemCard {
            VStack(spacing: 18) {
                DataInputField(
                    title: "Actual product mass / g",
                    text: $actualMass
                )

                DataInputField(
                    title: "Theoretical yield / g",
                    text: $theoreticalMass
                )
            }
        }
    }

    private var yieldCard: some View {
        ChemCard {
            HStack(spacing: 22) {
                ZStack {
                    Circle()
                        .stroke(ChemVaultTheme.elevatedCard, lineWidth: 14)
                        .frame(width: 130, height: 130)

                    Circle()
                        .trim(from: 0, to: progressFraction)
                        .stroke(
                            ChemVaultTheme.accent,
                            style: StrokeStyle(lineWidth: 14, lineCap: .round)
                        )
                        .frame(width: 130, height: 130)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(response: 0.7, dampingFraction: 0.85), value: progressFraction)

                    VStack(spacing: 2) {
                        if let yieldValue {
                            Text("\(yieldValue, specifier: "%.1f")")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(ChemVaultTheme.text)
                            Text("%")
                                .font(.caption.bold())
                                .foregroundStyle(ChemVaultTheme.secondaryText)
                        } else {
                            Text("--")
                                .font(.title.bold())
                                .foregroundStyle(ChemVaultTheme.secondaryText)
                        }
                    }
                }
                .scanSweep(active: true, tint: yieldDiagnosis.tint, cornerRadius: 70)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Percentage Yield")
                        .font(.title2.bold())
                        .foregroundStyle(ChemVaultTheme.text)

                    Text("actual ÷ theoretical × 100")
                        .font(.subheadline.monospaced())
                        .foregroundStyle(ChemVaultTheme.softAccent)

                    Text("Yield is evidence, not just a number.")
                        .font(.body)
                        .foregroundStyle(ChemVaultTheme.secondaryText)
                }

                Spacer()
            }
        }
    }

    private var interpretationCard: some View {
        ChemCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    DiagnosticSeal(
                        title: yieldDiagnosis == .notCalculated ? "awaiting data" : "diagnosed",
                        icon: yieldDiagnosis.icon,
                        tint: yieldDiagnosis.tint
                    )

                    Text("Interpretation")
                        .font(.title3.bold())
                        .foregroundStyle(ChemVaultTheme.text)
                }

                Text(interpretationText)
                    .font(.body)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var diagnosisCard: some View {
        ChemCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Label("Most likely explanation", systemImage: "folder.badge.gearshape")
                        .font(.title3.bold())
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()

                    DiagnosticSeal(
                        title: yieldDiagnosis.title,
                        icon: yieldDiagnosis.icon,
                        tint: yieldDiagnosis.tint
                    )
                }

                Text(yieldDiagnosis.notebookInterpretation)
                    .font(.body)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var yieldBandCard: some View {
        ChemCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("Forensic Yield Bands", systemImage: "waveform.path.ecg.rectangle")
                        .font(.title3.bold())
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()
                }

                VStack(spacing: 8) {
                    YieldBandRow(title: "< 40%", detail: "Low: moisture, incomplete reaction, transfer loss", active: yieldDiagnosis == .low, tint: ChemVaultTheme.warning)
                    YieldBandRow(title: "40-80%", detail: "Reasonable: reaction worked with normal workup loss", active: yieldDiagnosis == .reasonable, tint: ChemVaultTheme.success)
                    YieldBandRow(title: "80-100%", detail: "High: promising, still needs purity confirmation", active: yieldDiagnosis == .high, tint: ChemVaultTheme.softAccent)
                    YieldBandRow(title: "> 100%", detail: "Suspicious: wet product, solvent, impurity, weighing error", active: yieldDiagnosis == .suspicious, tint: ChemVaultTheme.warning)
                }

                Text(caseLinkedDataExplanation)
                    .font(.caption)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var progressFraction: CGFloat {
        guard let yieldValue else { return 0 }
        return CGFloat(min(max(yieldValue / 100, 0), 1))
    }

    private var yieldDiagnosis: YieldDiagnosis {
        YieldDiagnosis.classify(yieldValue)
    }

    private var interpretationText: String {
        switch yieldDiagnosis {
        case .notCalculated:
            return "Enter valid values to receive feedback."
        case .suspicious:
            return "A yield above 100% usually suggests impurities, residual solvent, or weighing error. The product may not be fully dry."
        case .low:
            return "Low yield may indicate wet glassware, incomplete reaction, side reactions, transfer loss, or product loss during purification."
        case .reasonable:
            return "This is a reasonable experimental yield. The reaction likely worked, although some loss during workup or purification is expected."
        case .high:
            return "This is a high yield. It is still important to confirm purity using analytical data such as IR or NMR."
        }
    }

    private var caseLinkedDataExplanation: String {
        if !caseFile.safetyDiagnosis.identifiedMoistureRisk {
            return "The ledger still lacks the strongest safety clue, so a low yield should be treated as possible moisture damage until proven otherwise."
        }

        if !caseFile.challengeResult.misconceptions.isEmpty {
            return "Because the mechanism challenge found misconceptions, use yield data carefully: the notebook should separate experimental loss from mechanism misunderstanding."
        }

        return "The safety and mechanism evidence make the yield meaningful: the number now acts as experimental evidence, not an isolated calculation."
    }
}

struct YieldBandRow: View {
    let title: String
    let detail: String
    let active: Bool
    let tint: Color

    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(active ? .black : ChemVaultTheme.secondaryText)
                .frame(width: 58)
                .padding(.vertical, 7)
                .background(active ? tint : .white.opacity(0.065))
                .clipShape(Capsule())

            Text(detail)
                .font(.caption)
                .foregroundStyle(active ? ChemVaultTheme.text : ChemVaultTheme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(9)
        .background(active ? tint.opacity(0.12) : .white.opacity(0.035))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .scanSweep(active: active, tint: tint, cornerRadius: 14)
    }
}

struct DataInputField: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundStyle(ChemVaultTheme.text)

            TextField("Enter value", text: $text)
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(ChemVaultTheme.elevatedCard)
                .foregroundStyle(ChemVaultTheme.text)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )
        }
    }
}
