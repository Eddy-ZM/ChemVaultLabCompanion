import SwiftUI

struct HomeView: View {
    let onStart: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                Spacer(minLength: 36)

                hero
                    .smoothAppear(delay: 0.05)

                caseDossier
                    .smoothAppear(delay: 0.16)

                routeCards
                    .smoothAppear(delay: 0.27)

                startButton
                    .smoothAppear(delay: 0.38)

                Spacer(minLength: 32)
            }
            .padding(24)
            .frame(maxWidth: 780)
            .frame(maxWidth: .infinity)
        }
    }

    private var hero: some View {
        VStack(spacing: 22) {
            ZStack {
                Circle()
                    .fill(ChemVaultTheme.accent.opacity(0.18))
                    .frame(width: 132, height: 132)
                    .blur(radius: 4)

                Circle()
                    .stroke(ChemVaultTheme.accent.opacity(0.25), lineWidth: 1)
                    .frame(width: 146, height: 146)

                Image(systemName: "atom")
                    .font(.system(size: 76, weight: .medium))
                    .foregroundStyle(ChemVaultTheme.accent)
            }
            .floating(amount: 5)

            VStack(spacing: 8) {
                Text("ChemVault")
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .foregroundStyle(ChemVaultTheme.text)

                Text("Lab Companion")
                    .font(.system(size: 31, weight: .semibold, design: .rounded))
                    .foregroundStyle(ChemVaultTheme.softAccent)

                Text("A pre-lab case file for invisible reaction logic.")
                    .font(.title3)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
        }
    }

    private var caseDossier: some View {
        PremiumGlassPanel(cornerRadius: 32) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Case 04", systemImage: "folder.badge.questionmark")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()

                    Text("Research Mode")
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(ChemVaultTheme.accent)
                        .clipShape(Capsule())
                }

                Text("The Vanishing Grignard Yield")
                    .font(.title3.bold())
                    .foregroundStyle(ChemVaultTheme.text)

                Text("Diagnose a low-yield tert-butanol synthesis by linking dry glassware, C-Mg polarity, carbonyl activation, alkoxide formation, and yield evidence into one notebook-ready conclusion.")
                    .font(.subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Divider()
                    .background(.white.opacity(0.12))

                VStack(spacing: 10) {
                    CaseDossierRow(
                        icon: "drop.triangle",
                        label: "Primary risk",
                        value: "Moisture destroys the reagent"
                    )

                    CaseDossierRow(
                        icon: "arrow.triangle.branch",
                        label: "Core proof",
                        value: "Curved arrows explain bond changes"
                    )

                    CaseDossierRow(
                        icon: "doc.text.magnifyingglass",
                        label: "Final artifact",
                        value: "Generated mentor-style lab notebook"
                    )
                }
            }
        }
    }

    private var routeCards: some View {
        HStack(spacing: 12) {
            HomeRouteCard(
                icon: "shield.lefthalf.filled",
                title: "Safety",
                subtitle: "Dry glassware"
            )

            HomeRouteCard(
                icon: "arrow.triangle.branch",
                title: "Mechanism",
                subtitle: "Electron flow"
            )

            HomeRouteCard(
                icon: "chart.bar.xaxis",
                title: "Data",
                subtitle: "Yield insight"
            )
        }
    }

    private var startButton: some View {
        LiquidGlassButton(
            title: "Enter Lab Mission",
            icon: "play.fill"
        ) {
            onStart()
        }
    }
}

struct HomeRouteCard: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(ChemVaultTheme.accent)

            Text(title)
                .font(.headline)
                .foregroundStyle(ChemVaultTheme.text)

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(ChemVaultTheme.tertiaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .chemGlass(
            cornerRadius: 24,
            tint: ChemVaultTheme.accent.opacity(0.06),
            interactive: true
        )
        .pressableFeedback()
    }
}

struct CaseDossierRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 11) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.accent)
                .frame(width: 22)

            Text(label)
                .font(.caption.bold())
                .foregroundStyle(ChemVaultTheme.tertiaryText)
                .frame(width: 82, alignment: .leading)

            Text(value)
                .font(.caption.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(10)
        .background(.white.opacity(0.045))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
