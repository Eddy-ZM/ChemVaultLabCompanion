import Foundation
import SwiftUI

struct LabCaseFile: Equatable {
    var safetyDiagnosis = SafetyDiagnosis()
    var challengeResult = MechanismChallengeResult()
    var yieldRecord = YieldRecord()
    var reviewedMechanismProofIDs: Set<String> = []

    private var confirmedMechanismProofs: Int {
        MechanismProof.allCases.filter { reviewedMechanismProofIDs.contains($0.rawValue) }.count
    }

    private var completedMechanismCinema: Bool {
        confirmedMechanismProofs == MechanismProof.allCases.count
    }

    var readiness: LabReadiness {
        if yieldRecord.diagnosis == .suspicious {
            return .dataSuspicious
        }

        if !safetyDiagnosis.identifiedMoistureRisk || !challengeResult.misconceptions.isEmpty {
            return .needsReview
        }

        if challengeResult.totalQuestions == 0 || yieldRecord.diagnosis == .notCalculated {
            return .inProgress
        }

        return .ready
    }

    var evidenceItems: [CaseEvidenceItem] {
        let safety = CaseEvidenceItem(
            id: "safety-moisture",
            title: "Moisture risk",
            detail: safetyDiagnosis.identifiedMoistureRisk
                ? "Wet glassware was identified as the reagent killer."
                : "Find why water destroys the C-Mg bond.",
            icon: "drop.triangle.fill",
            tintRole: safetyDiagnosis.identifiedMoistureRisk ? .success : .warning,
            isConfirmed: safetyDiagnosis.identifiedMoistureRisk
        )

        let mechanism = MechanismProof.allCases.map { proof in
            proof.evidenceItem(isConfirmed: reviewedMechanismProofIDs.contains(proof.rawValue))
        }

        let challenge = CaseEvidenceItem(
            id: "challenge-diagnosis",
            title: "Reasoning check",
            detail: challengeResult.totalQuestions == 0
                ? "Complete the mechanism challenge."
                : "Challenge score: \(challengeResult.scoreText)",
            icon: challengeResult.misconceptions.isEmpty ? "checkmark.seal.fill" : "brain.head.profile",
            tintRole: challengeResult.totalQuestions == 0 ? .neutral : (challengeResult.misconceptions.isEmpty ? .success : .warning),
            isConfirmed: challengeResult.totalQuestions > 0 && challengeResult.misconceptions.isEmpty
        )

        let data = CaseEvidenceItem(
            id: "yield-diagnosis",
            title: "Yield diagnosis",
            detail: yieldRecord.diagnosis == .notCalculated
                ? "Enter mass data to classify yield."
                : yieldSummary,
            icon: yieldRecord.diagnosis.icon,
            tintRole: yieldRecord.diagnosis == .notCalculated ? .neutral : (yieldRecord.diagnosis == .suspicious ? .warning : .success),
            isConfirmed: yieldRecord.diagnosis != .notCalculated && yieldRecord.diagnosis != .suspicious
        )

        return [safety] + mechanism + [challenge, data]
    }

    var evidenceCompletion: Double {
        guard !evidenceItems.isEmpty else { return 0 }
        let confirmed = evidenceItems.filter(\.isConfirmed).count
        return Double(confirmed) / Double(evidenceItems.count)
    }

    var evidenceCompletionText: String {
        "\(Int((evidenceCompletion * 100).rounded()))%"
    }

    var confirmedEvidenceCount: Int {
        evidenceItems.filter(\.isConfirmed).count
    }

    var mechanismProofProgressText: String {
        "\(confirmedMechanismProofs)/\(MechanismProof.allCases.count)"
    }

    var unresolvedBlockers: [CaseBlocker] {
        var blockers: [CaseBlocker] = []

        if !safetyDiagnosis.identifiedMoistureRisk {
            blockers.append(
                CaseBlocker(
                    id: "moisture-risk",
                    title: "Moisture risk unresolved",
                    detail: "The case file still needs the key safety finding: water protonates and destroys the Grignard reagent.",
                    icon: "drop.triangle.fill"
                )
            )
        }

        if !completedMechanismCinema {
            blockers.append(
                CaseBlocker(
                    id: "mechanism-proof",
                    title: "Mechanism proof incomplete",
                    detail: "Review the mechanism cinema until the polarity, activation, electron-flow, intermediate, and workup evidence is collected.",
                    icon: "arrow.triangle.branch"
                )
            )
        }

        if challengeResult.totalQuestions == 0 {
            blockers.append(
                CaseBlocker(
                    id: "challenge-missing",
                    title: "Reasoning challenge missing",
                    detail: "Complete the mechanism challenge so the notebook can diagnose misconceptions.",
                    icon: "brain.head.profile"
                )
            )
        } else if !challengeResult.misconceptions.isEmpty {
            blockers.append(
                CaseBlocker(
                    id: "challenge-review",
                    title: "Mechanism misconception detected",
                    detail: challengeResult.misconceptions.map(\.revisionPrompt).joined(separator: " "),
                    icon: "exclamationmark.triangle.fill"
                )
            )
        }

        if yieldRecord.diagnosis == .notCalculated {
            blockers.append(
                CaseBlocker(
                    id: "yield-missing",
                    title: "Yield diagnosis missing",
                    detail: "Enter actual and theoretical mass values before trusting the final case verdict.",
                    icon: "chart.xyaxis.line"
                )
            )
        } else if yieldRecord.diagnosis == .suspicious {
            blockers.append(
                CaseBlocker(
                    id: "yield-suspicious",
                    title: "Yield data suspicious",
                    detail: "A yield above 100% suggests residual solvent, wet product, impurity, or weighing error.",
                    icon: "xmark.octagon.fill"
                )
            )
        }

        return blockers
    }

    var readinessScore: Int {
        let base = Int((evidenceCompletion * 100).rounded())

        switch readiness {
        case .ready:
            return base
        case .needsReview:
            return min(base, 74)
        case .dataSuspicious:
            return min(base, 62)
        case .inProgress:
            return min(base, 55)
        }
    }

    var mentorGrade: MentorGrade {
        if challengeResult.totalQuestions == 0 || yieldRecord.diagnosis == .notCalculated || !completedMechanismCinema {
            return .incomplete
        }

        if readiness == .dataSuspicious || readiness == .needsReview {
            return .review
        }

        if readinessScore >= 92 {
            return .distinction
        }

        return .strong
    }

    var nextRecommendation: String {
        if !safetyDiagnosis.identifiedMoistureRisk {
            return "Start by identifying wet glassware as the critical Grignard risk."
        }

        if !completedMechanismCinema {
            return "Review the Mechanism Cinema proof cards before writing the notebook conclusion."
        }

        if challengeResult.totalQuestions == 0 {
            return "Complete the mechanism challenge to test whether the evidence is understood."
        }

        if let misconception = challengeResult.misconceptions.first {
            return misconception.revisionPrompt
        }

        if yieldRecord.diagnosis == .notCalculated {
            return "Enter mass data to connect the mechanism to experimental quality."
        }

        if yieldRecord.diagnosis == .suspicious {
            return "Check whether the product was wet, impure, or weighed with residual solvent."
        }

        return "Use the generated conclusion as a concise pre-lab explanation."
    }

    var caseVerdict: String {
        switch readiness {
        case .inProgress:
            return "Evidence still being collected"
        case .ready:
            return "Case evidence supports lab readiness"
        case .needsReview:
            return "Case needs targeted mechanism review"
        case .dataSuspicious:
            return "Case blocked by suspicious data"
        }
    }

    var notebookConclusion: String {
        switch readiness {
        case .inProgress:
            return "The case file is not complete yet. Start by confirming the moisture risk, then collect the mechanism proof cards, complete the reasoning challenge, and classify the yield data."
        case .ready:
            return "The evidence supports a lab-ready Grignard explanation: dry conditions protect the C-Mg bond, the methyl carbon acts as the nucleophile, carbonyl activation and curved-arrow electron flow form a magnesium alkoxide, and acid workup gives the alcohol. The yield result, \(yieldSummary.lowercased()), is consistent with a realistic experimental outcome."
        case .needsReview:
            return "The case file needs review before it is notebook-ready. \(nextRecommendation) The final explanation should connect safety, nucleophilic attack, alkoxide formation, and workup without skipping the intermediate."
        case .dataSuspicious:
            return "The mechanism evidence may be strong, but the yield is above 100% or otherwise suspicious. Treat the data as unresolved until wet product, residual solvent, impurity, or weighing error has been checked."
        }
    }

    var conclusionTitle: String {
        switch readiness {
        case .inProgress:
            return "Case file in progress"
        case .ready:
            return "Lab-ready case file"
        case .needsReview:
            return "Review before entering the lab"
        case .dataSuspicious:
            return "Data needs checking"
        }
    }

    var safetySummary: String {
        if safetyDiagnosis.identifiedMoistureRisk {
            return "Moisture risk identified. Wet glassware can protonate and destroy the C-Mg bond before carbonyl attack."
        }

        if safetyDiagnosis.selectedRiskIDs.isEmpty {
            return "No safety risks were selected. Recheck the case file before entering the lab."
        }

        return "Moisture was not selected as a critical finding. Review why Grignard reagents require dry conditions."
    }

    var yieldSummary: String {
        guard let percent = yieldRecord.percent else {
            return yieldRecord.diagnosis.notebookInterpretation
        }

        return "\(percent.formatted(.number.precision(.fractionLength(1))))% - \(yieldRecord.diagnosis.notebookInterpretation)"
    }

    var mentorNote: String {
        switch readiness {
        case .inProgress:
            return "Complete the safety, mechanism, and data checks to generate a full notebook conclusion."
        case .ready:
            return "You connected the safety conditions, electron flow, intermediate, workup, and yield evidence into one coherent explanation."
        case .needsReview:
            if !safetyDiagnosis.identifiedMoistureRisk {
                return "Review why water destroys the polar C-Mg bond before the reagent can attack the carbonyl."
            }

            return "Review \(challengeResult.misconceptionSummary.lowercased()) before using this mechanism in the real lab."
        case .dataSuspicious:
            return "Check whether the sample was still wet, contained solvent, or was weighed incorrectly before trusting this yield."
        }
    }

    static let sampleReady = LabCaseFile(
        safetyDiagnosis: SafetyDiagnosis(
            selectedRiskIDs: ["moisture", "flame"],
            identifiedMoistureRisk: true
        ),
        challengeResult: MechanismChallengeResult(
            correctAnswers: 4,
            totalQuestions: 4,
            misconceptions: []
        ),
        yieldRecord: YieldRecord(percent: 68.5, diagnosis: .reasonable),
        reviewedMechanismProofIDs: Set(MechanismProof.allCases.map(\.rawValue))
    )
}

struct CaseEvidenceItem: Identifiable, Equatable {
    let id: String
    let title: String
    let detail: String
    let icon: String
    let tintRole: CaseTintRole
    let isConfirmed: Bool
}

struct CaseBlocker: Identifiable, Equatable {
    let id: String
    let title: String
    let detail: String
    let icon: String
}

enum CaseTintRole: Equatable {
    case accent
    case success
    case mechanism
    case warning
    case neutral

    var color: Color {
        switch self {
        case .accent:
            return ChemVaultTheme.accent
        case .success:
            return ChemVaultTheme.success
        case .mechanism:
            return ChemVaultTheme.softAccent
        case .warning:
            return ChemVaultTheme.warning
        case .neutral:
            return ChemVaultTheme.tertiaryText
        }
    }
}

enum MentorGrade: String, Equatable {
    case distinction = "A"
    case strong = "B+"
    case review = "C"
    case incomplete = "In progress"

    var title: String {
        switch self {
        case .distinction:
            return "Distinction"
        case .strong:
            return "Strong"
        case .review:
            return "Review"
        case .incomplete:
            return "Collecting evidence"
        }
    }

    var tintRole: CaseTintRole {
        switch self {
        case .distinction, .strong:
            return .success
        case .review:
            return .warning
        case .incomplete:
            return .accent
        }
    }
}

enum MechanismProof: String, CaseIterable, Equatable {
    case polarity
    case coordination
    case orbitalAlignment
    case electronFlow
    case alkoxide
    case workup

    var title: String {
        switch self {
        case .polarity:
            return "C-Mg polarity"
        case .coordination:
            return "O to Mg activation"
        case .orbitalAlignment:
            return "HOMO to LUMO match"
        case .electronFlow:
            return "Curved-arrow proof"
        case .alkoxide:
            return "Alkoxide intermediate"
        case .workup:
            return "Acid workup"
        }
    }

    var detail: String {
        switch self {
        case .polarity:
            return "The methyl carbon carries nucleophilic character."
        case .coordination:
            return "Magnesium coordination makes the carbonyl easier to attack."
        case .orbitalAlignment:
            return "Electron donation is explained by orbital overlap."
        case .electronFlow:
            return "Bond formation and pi-electron movement happen together."
        case .alkoxide:
            return "The first product is a magnesium alkoxide, not the alcohol."
        case .workup:
            return "Acid workup protonates the alkoxide to finish the reaction."
        }
    }

    var icon: String {
        switch self {
        case .polarity:
            return "plusminus"
        case .coordination:
            return "link"
        case .orbitalAlignment:
            return "scope"
        case .electronFlow:
            return "arrow.triangle.branch"
        case .alkoxide:
            return "minus.circle.fill"
        case .workup:
            return "drop.fill"
        }
    }

    func evidenceItem(isConfirmed: Bool) -> CaseEvidenceItem {
        CaseEvidenceItem(
            id: "mechanism-\(rawValue)",
            title: title,
            detail: isConfirmed ? detail : "Review this scene in Mechanism Cinema.",
            icon: icon,
            tintRole: isConfirmed ? .mechanism : .neutral,
            isConfirmed: isConfirmed
        )
    }
}

struct SafetyDiagnosis: Equatable {
    var selectedRiskIDs: Set<String> = []
    var identifiedMoistureRisk = false
}

struct MechanismChallengeResult: Equatable {
    var correctAnswers = 0
    var totalQuestions = 0
    var misconceptions: [MechanismMisconception] = []

    var scoreText: String {
        totalQuestions == 0 ? "Not attempted" : "\(correctAnswers)/\(totalQuestions)"
    }

    var misconceptionSummary: String {
        if misconceptions.isEmpty {
            return "No major mechanism misconceptions were detected"
        }

        return misconceptions.map(\.title).joined(separator: ", ")
    }
}

struct YieldRecord: Equatable {
    var percent: Double?
    var diagnosis: YieldDiagnosis = .notCalculated
}

enum LabReadiness: Equatable {
    case inProgress
    case ready
    case needsReview
    case dataSuspicious

    var statusText: String {
        switch self {
        case .inProgress:
            return "In progress"
        case .ready:
            return "Ready"
        case .needsReview:
            return "Review"
        case .dataSuspicious:
            return "Check data"
        }
    }

    var tint: Color {
        switch self {
        case .inProgress:
            return ChemVaultTheme.accent
        case .ready:
            return ChemVaultTheme.success
        case .needsReview:
            return ChemVaultTheme.accent
        case .dataSuspicious:
            return ChemVaultTheme.warning
        }
    }

    var icon: String {
        switch self {
        case .inProgress:
            return "hourglass.circle.fill"
        case .ready:
            return "checkmark.seal.fill"
        case .needsReview:
            return "exclamationmark.triangle.fill"
        case .dataSuspicious:
            return "xmark.octagon.fill"
        }
    }
}

enum MechanismMisconception: String, CaseIterable, Equatable {
    case reactiveSite
    case electronFlow
    case workupTiming
    case protonation

    var title: String {
        switch self {
        case .reactiveSite:
            return "Reactive-site misconception"
        case .electronFlow:
            return "Arrow-pushing misconception"
        case .workupTiming:
            return "Workup timing misconception"
        case .protonation:
            return "Protonation misconception"
        }
    }

    var revisionPrompt: String {
        switch self {
        case .reactiveSite:
            return "Start the nucleophilic attack from the methyl carbon attached to Mg."
        case .electronFlow:
            return "Move the C=O pi electrons onto oxygen while the new C-C bond forms."
        case .workupTiming:
            return "Show the magnesium alkoxide before drawing the neutral alcohol."
        case .protonation:
            return "Use acid workup to protonate the alkoxide oxygen."
        }
    }
}

enum YieldDiagnosis: String, Equatable {
    case notCalculated
    case low
    case reasonable
    case high
    case suspicious

    static func classify(_ percent: Double?) -> YieldDiagnosis {
        guard let percent else { return .notCalculated }

        if percent > 100 {
            return .suspicious
        } else if percent < 40 {
            return .low
        } else if percent <= 80 {
            return .reasonable
        } else {
            return .high
        }
    }

    var title: String {
        switch self {
        case .notCalculated:
            return "Yield not calculated"
        case .low:
            return "Low yield"
        case .reasonable:
            return "Reasonable yield"
        case .high:
            return "High yield"
        case .suspicious:
            return "Suspicious yield"
        }
    }

    var notebookInterpretation: String {
        switch self {
        case .notCalculated:
            return "Enter valid mass values before writing a yield conclusion."
        case .low:
            return "Low yield supports a diagnosis such as moisture contamination, incomplete reaction, transfer loss, or purification loss."
        case .reasonable:
            return "The reaction likely worked, with expected loss during workup or purification."
        case .high:
            return "High yield is promising, but purity still needs confirmation with analytical data."
        case .suspicious:
            return "A yield above 100% suggests residual solvent, wet product, impurity, or weighing error."
        }
    }

    var icon: String {
        switch self {
        case .notCalculated:
            return "questionmark.circle"
        case .low:
            return "exclamationmark.triangle.fill"
        case .reasonable:
            return "checkmark.circle.fill"
        case .high:
            return "star.circle.fill"
        case .suspicious:
            return "xmark.octagon.fill"
        }
    }

    var tint: Color {
        switch self {
        case .notCalculated:
            return ChemVaultTheme.secondaryText
        case .low, .suspicious:
            return ChemVaultTheme.warning
        case .reasonable, .high:
            return ChemVaultTheme.success
        }
    }
}
