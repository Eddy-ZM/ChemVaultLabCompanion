import Foundation
import SwiftUI

struct LabCaseFile: Equatable {
    var safetyDiagnosis = SafetyDiagnosis()
    var challengeResult = MechanismChallengeResult()
    var yieldRecord = YieldRecord()

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
        yieldRecord: YieldRecord(percent: 68.5, diagnosis: .reasonable)
    )
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
