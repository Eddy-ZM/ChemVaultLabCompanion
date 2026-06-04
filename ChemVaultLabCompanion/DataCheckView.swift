import SwiftUI

struct DataCheckView: View {
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
        ScrollView {
            VStack(spacing: 24) {
                ProgressHeaderView(
                    currentStep: 3,
                    title: "Data Check",
                    subtitle: "Connect mass measurements to experimental quality."
                )
                .smoothAppear(delay: 0.04)

                inputCard
                    .smoothAppear(delay: 0.16)

                yieldCard
                    .smoothAppear(delay: 0.28)

                interpretationCard
                    .smoothAppear(delay: 0.40)

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
            .padding(24)
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
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
                    Image(systemName: yieldDiagnosis.icon)
                        .foregroundStyle(yieldDiagnosis.tint)

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

                    Text(yieldDiagnosis.title)
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(yieldDiagnosis.tint)
                        .clipShape(Capsule())
                }

                Text(yieldDiagnosis.notebookInterpretation)
                    .font(.body)
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
