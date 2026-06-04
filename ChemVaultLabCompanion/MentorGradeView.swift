import SwiftUI

struct MentorGradeView: View {
    let caseFile: LabCaseFile
    let compact: Bool

    var body: some View {
        HStack(alignment: .center, spacing: compact ? 12 : 16) {
            gradeBadge

            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    Text(caseFile.mentorGrade.title)
                        .font(compact ? .headline : .title3.bold())
                        .foregroundStyle(ChemVaultTheme.text)

                    Spacer()

                    Text("\(caseFile.readinessScore)/100")
                        .font(.caption.bold())
                        .foregroundStyle(caseFile.mentorGrade.tintRole.color)
                }

                EvidenceProgressBar(
                    progress: Double(caseFile.readinessScore) / 100,
                    tint: caseFile.mentorGrade.tintRole.color
                )
                .frame(height: 10)

                Text(caseFile.nextRecommendation)
                    .font(.caption)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(caseFile.mentorGrade.tintRole.color.opacity(0.18), lineWidth: 1)
        )
    }

    private var gradeBadge: some View {
        ZStack {
            Circle()
                .fill(caseFile.mentorGrade.tintRole.color.opacity(0.20))
                .frame(width: compact ? 58 : 72, height: compact ? 58 : 72)

            Circle()
                .stroke(caseFile.mentorGrade.tintRole.color.opacity(0.35), lineWidth: 1)
                .frame(width: compact ? 68 : 84, height: compact ? 68 : 84)

            Text(caseFile.mentorGrade.rawValue)
                .font(.system(size: compact ? 18 : 24, weight: .black, design: .rounded))
                .foregroundStyle(caseFile.mentorGrade.tintRole.color)
                .minimumScaleFactor(0.55)
                .lineLimit(1)
        }
        .frame(width: compact ? 72 : 88, height: compact ? 72 : 88)
    }
}

#Preview {
    ZStack {
        AppBackgroundView()
        PremiumGlassPanel {
            MentorGradeView(caseFile: .sampleReady, compact: false)
        }
        .padding()
    }
}
