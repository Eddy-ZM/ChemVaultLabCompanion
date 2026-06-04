import SwiftUI

struct CaseTimelineView: View {
    let items: [CaseEvidenceItem]
    let compact: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Evidence Chain", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.text)

                Spacer()
            }

            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    CaseTimelineRow(
                        item: item,
                        isLast: index == items.count - 1,
                        compact: compact
                    )
                }
            }
        }
    }
}

private struct CaseTimelineRow: View {
    let item: CaseEvidenceItem
    let isLast: Bool
    let compact: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(item.tintRole.color.opacity(item.isConfirmed ? 0.24 : 0.10))
                        .frame(width: 34, height: 34)

                    Image(systemName: item.isConfirmed ? "checkmark" : item.icon)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(item.tintRole.color)
                }

                if !isLast {
                    Rectangle()
                        .fill(item.isConfirmed ? item.tintRole.color.opacity(0.30) : .white.opacity(0.10))
                        .frame(width: 2, height: compact ? 34 : 42)
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(item.title)
                        .font(compact ? .subheadline.bold() : .headline)
                        .foregroundStyle(ChemVaultTheme.text)

                    Text(item.isConfirmed ? "Confirmed" : "Open")
                        .font(.caption2.bold())
                        .foregroundStyle(item.isConfirmed ? .black : ChemVaultTheme.secondaryText)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(item.isConfirmed ? item.tintRole.color : .white.opacity(0.075))
                        .clipShape(Capsule())
                }

                Text(item.detail)
                    .font(compact ? .caption : .subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, isLast ? 0 : 12)

            Spacer(minLength: 0)
        }
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        PremiumGlassPanel {
            CaseTimelineView(items: LabCaseFile.sampleReady.evidenceItems, compact: false)
        }
        .padding()
    }
}
