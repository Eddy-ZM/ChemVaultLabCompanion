import SwiftUI

struct EvidenceLedgerView: View {
    let caseFile: LabCaseFile
    let compact: Bool

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: 8),
            count: compact ? 2 : 3
        )
    }

    var body: some View {
        PremiumGlassPanel(cornerRadius: compact ? 24 : 30) {
            VStack(alignment: .leading, spacing: 14) {
                header

                EvidenceProgressBar(
                    progress: caseFile.evidenceCompletion,
                    tint: caseFile.readiness.tint
                )
                .frame(height: 12)

                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(caseFile.evidenceItems) { item in
                        EvidenceLedgerChip(item: item)
                    }
                }

                HStack(spacing: 8) {
                    Image(systemName: caseFile.readiness.icon)
                        .foregroundStyle(caseFile.readiness.tint)

                    Text(caseFile.nextRecommendation)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(ChemVaultTheme.secondaryText)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 2)
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Label("Evidence Command", systemImage: "folder.badge.gearshape")
                    .font(compact ? .subheadline.bold() : .headline)
                    .foregroundStyle(ChemVaultTheme.text)

                Text(caseFile.caseVerdict)
                    .font(.caption)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(caseFile.evidenceCompletionText)
                    .font(.system(size: compact ? 22 : 28, weight: .bold, design: .rounded))
                    .foregroundStyle(caseFile.readiness.tint)

                Text("\(caseFile.confirmedEvidenceCount)/\(caseFile.evidenceItems.count) proof")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
            }
        }
    }
}

struct EvidenceProgressBar: View {
    let progress: Double
    let tint: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.white.opacity(0.08))

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
                    .frame(width: proxy.size.width * max(0, min(1, progress)))
            }
        }
    }
}

private struct EvidenceLedgerChip: View {
    let item: CaseEvidenceItem

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(item.tintRole.color.opacity(item.isConfirmed ? 0.22 : 0.10))
                    .frame(width: 30, height: 30)

                Image(systemName: item.isConfirmed ? "checkmark" : item.icon)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(item.tintRole.color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.caption.bold())
                    .foregroundStyle(ChemVaultTheme.text)
                    .lineLimit(1)

                Text(item.isConfirmed ? "Confirmed" : "Open")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(item.isConfirmed ? item.tintRole.color : ChemVaultTheme.tertiaryText)
            }

            Spacer(minLength: 0)
        }
        .padding(9)
        .frame(minHeight: 52)
        .background(.white.opacity(item.isConfirmed ? 0.065 : 0.035))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(item.tintRole.color.opacity(item.isConfirmed ? 0.20 : 0.08), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        EvidenceLedgerView(caseFile: .sampleReady, compact: false)
            .padding()
    }
}
