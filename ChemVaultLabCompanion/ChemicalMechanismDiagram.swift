import SwiftUI

struct ChemicalMechanismDiagram: View {
    let step: Int
    let arrowProgress: CGFloat
    let secondArrowProgress: CGFloat
    let showAlkoxide: Bool
    let showProduct: Bool

    @State private var selectedHint: String?

    var body: some View {
        ZStack {
            if showProduct {
                finalProduct
                    .transition(.scale.combined(with: .opacity))
            } else {
                mechanismMap
            }
        }
        .animation(.spring(response: 0.55, dampingFraction: 0.82), value: showProduct)
        .animation(.spring(response: 0.55, dampingFraction: 0.82), value: showAlkoxide)
    }

    private var mechanismMap: some View {
        ZStack {
            VStack(spacing: 18) {
                HStack(spacing: 26) {
                    grignardFragment

                    Text("+")
                        .font(.title.bold())
                        .foregroundStyle(ChemVaultTheme.secondaryText)

                    carbonylFragment
                }

                if let selectedHint {
                    Text(selectedHint)
                        .font(.caption)
                        .foregroundStyle(ChemVaultTheme.softAccent)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(ChemVaultTheme.background)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    Text("Tap atoms or charges to reveal why they matter.")
                        .font(.caption)
                        .foregroundStyle(ChemVaultTheme.tertiaryText)
                }
            }

            CurvedArrowShape(progress: arrowProgress)
                .stroke(
                    ChemVaultTheme.accent,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                )
                .frame(width: 185, height: 130)
                .offset(x: 8, y: -30)
                .shadow(color: ChemVaultTheme.accent.opacity(0.55), radius: 8)

            CurvedArrowShape(progress: secondArrowProgress)
                .stroke(
                    ChemVaultTheme.softAccent,
                    style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)
                )
                .frame(width: 105, height: 80)
                .rotationEffect(.degrees(-35))
                .offset(x: 122, y: -60)
                .shadow(color: ChemVaultTheme.softAccent.opacity(0.45), radius: 8)
        }
    }

    private var grignardFragment: some View {
        VStack(spacing: 8) {
            Text("Grignard reagent")
                .font(.caption.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.secondaryText)

            HStack(spacing: 6) {
                atomButton(
                    label: "R",
                    charge: "δ−",
                    hint: "The carbon group behaves like a strong nucleophile because the C–Mg bond is highly polarised."
                )

                bond

                atomButton(
                    label: "MgBr",
                    charge: "δ+",
                    hint: "Magnesium is electropositive, making the carbon attached to it electron-rich."
                )
            }

            Text("R–MgBr")
                .font(.caption.monospaced())
                .foregroundStyle(ChemVaultTheme.tertiaryText)
        }
        .padding()
        .background(ChemVaultTheme.elevatedCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var carbonylFragment: some View {
        VStack(spacing: 8) {
            Text(showAlkoxide ? "Alkoxide intermediate" : "Carbonyl compound")
                .font(.caption.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.secondaryText)

            if showAlkoxide {
                VStack(spacing: 4) {
                    atomButton(
                        label: "O",
                        charge: "−",
                        hint: "Oxygen now carries the negative charge after the π bond electrons move onto oxygen."
                    )

                    singleBondVertical

                    HStack(spacing: 6) {
                        Text("R")
                            .foregroundStyle(ChemVaultTheme.secondaryText)
                        bond
                        atomButton(
                            label: "C",
                            charge: "",
                            hint: "This carbon now has a new C–C bond from the Grignard reagent."
                        )
                        bond
                        Text("R")
                            .foregroundStyle(ChemVaultTheme.secondaryText)
                    }
                }
            } else {
                VStack(spacing: 4) {
                    atomButton(
                        label: "O",
                        charge: "δ−",
                        hint: "Oxygen is more electronegative, so the C=O bond is polarised toward oxygen."
                    )

                    doubleBondVertical

                    HStack(spacing: 6) {
                        Text("R")
                            .foregroundStyle(ChemVaultTheme.secondaryText)
                        bond
                        atomButton(
                            label: "C",
                            charge: "δ+",
                            hint: "The carbonyl carbon is electrophilic and is attacked by the Grignard carbon nucleophile."
                        )
                        bond
                        Text("R")
                            .foregroundStyle(ChemVaultTheme.secondaryText)
                    }
                }
            }

            Text(showAlkoxide ? "R₃C–O⁻" : "R₂C=O")
                .font(.caption.monospaced())
                .foregroundStyle(ChemVaultTheme.tertiaryText)
        }
        .padding()
        .background(ChemVaultTheme.elevatedCard)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var finalProduct: some View {
        VStack(spacing: 18) {
            Text("Alcohol product")
                .font(.headline)
                .foregroundStyle(ChemVaultTheme.secondaryText)

            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    atomText("O")
                    singleBondHorizontal
                    atomText("H")
                }

                singleBondVertical

                HStack(spacing: 6) {
                    Text("R")
                        .foregroundStyle(ChemVaultTheme.secondaryText)
                    bond
                    atomText("C")
                    bond
                    Text("R")
                        .foregroundStyle(ChemVaultTheme.secondaryText)
                }

                Text("│")
                    .foregroundStyle(ChemVaultTheme.secondaryText)

                Text("R")
                    .foregroundStyle(ChemVaultTheme.secondaryText)
            }
            .padding()
            .background(ChemVaultTheme.elevatedCard)
            .clipShape(RoundedRectangle(cornerRadius: 22))

            Text("Acid workup protonates the alkoxide: O⁻ → OH.")
                .font(.body)
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
    }

    private func atomButton(label: String, charge: String, hint: String) -> some View {
        Button {
            withAnimation {
                selectedHint = hint
            }
        } label: {
            VStack(spacing: 2) {
                if !charge.isEmpty {
                    Text(charge)
                        .font(.caption2.bold())
                        .foregroundStyle(ChemVaultTheme.accent)
                }

                Text(label)
                    .font(.title3.bold())
                    .foregroundStyle(ChemVaultTheme.text)
                    .frame(minWidth: 34, minHeight: 34)
                    .background(ChemVaultTheme.background)
                    .clipShape(Circle())
            }
        }
        .buttonStyle(.plain)
    }

    private func atomText(_ label: String) -> some View {
        Text(label)
            .font(.title3.bold())
            .foregroundStyle(ChemVaultTheme.text)
            .frame(minWidth: 34, minHeight: 34)
            .background(ChemVaultTheme.background)
            .clipShape(Circle())
    }

    private var bond: some View {
        Rectangle()
            .fill(ChemVaultTheme.secondaryText)
            .frame(width: 22, height: 2)
    }

    private var singleBondHorizontal: some View {
        Rectangle()
            .fill(ChemVaultTheme.secondaryText)
            .frame(width: 18, height: 2)
    }

    private var singleBondVertical: some View {
        Rectangle()
            .fill(ChemVaultTheme.secondaryText)
            .frame(width: 2, height: 20)
    }

    private var doubleBondVertical: some View {
        HStack(spacing: 4) {
            Rectangle()
                .fill(ChemVaultTheme.secondaryText)
                .frame(width: 2, height: 24)

            Rectangle()
                .fill(ChemVaultTheme.secondaryText)
                .frame(width: 2, height: 24)
        }
    }
}
