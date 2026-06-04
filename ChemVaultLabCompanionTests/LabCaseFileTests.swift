import Testing
@testable import ChemVaultLabCompanion

struct LabCaseFileTests {
    @Test func yieldDiagnosisClassifiesCommonRanges() {
        #expect(YieldDiagnosis.classify(nil) == .notCalculated)
        #expect(YieldDiagnosis.classify(25) == .low)
        #expect(YieldDiagnosis.classify(68.5) == .reasonable)
        #expect(YieldDiagnosis.classify(91) == .high)
        #expect(YieldDiagnosis.classify(120) == .suspicious)
    }

    @Test func readinessReflectsSafetyMechanismAndData() {
        var caseFile = LabCaseFile()
        caseFile.safetyDiagnosis = SafetyDiagnosis(
            selectedRiskIDs: ["moisture", "flame"],
            identifiedMoistureRisk: true
        )
        caseFile.challengeResult = MechanismChallengeResult(
            correctAnswers: 4,
            totalQuestions: 4,
            misconceptions: []
        )
        caseFile.yieldRecord = YieldRecord(percent: 68.5, diagnosis: .reasonable)

        #expect(caseFile.readiness == .ready)
        #expect(caseFile.conclusionTitle == "Lab-ready case file")
    }

    @Test func readinessFlagsMisconceptions() {
        var caseFile = LabCaseFile()
        caseFile.safetyDiagnosis = SafetyDiagnosis(
            selectedRiskIDs: ["moisture"],
            identifiedMoistureRisk: true
        )
        caseFile.challengeResult = MechanismChallengeResult(
            correctAnswers: 2,
            totalQuestions: 4,
            misconceptions: [.electronFlow, .workupTiming]
        )
        caseFile.yieldRecord = YieldRecord(percent: 68.5, diagnosis: .reasonable)

        #expect(caseFile.readiness == .needsReview)
        #expect(caseFile.mentorNote.contains("Review"))
    }

    @Test func readinessFlagsSuspiciousData() {
        var caseFile = LabCaseFile()
        caseFile.safetyDiagnosis = SafetyDiagnosis(
            selectedRiskIDs: ["moisture"],
            identifiedMoistureRisk: true
        )
        caseFile.challengeResult = MechanismChallengeResult(
            correctAnswers: 4,
            totalQuestions: 4,
            misconceptions: []
        )
        caseFile.yieldRecord = YieldRecord(percent: 130, diagnosis: .suspicious)

        #expect(caseFile.readiness == .dataSuspicious)
        #expect(caseFile.conclusionTitle == "Data needs checking")
    }
}
