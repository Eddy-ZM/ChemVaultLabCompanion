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

        #expect(caseFile.readiness.statusText == "Ready")
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

        #expect(caseFile.readiness.statusText == "Review")
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

        #expect(caseFile.readiness.statusText == "Check data")
        #expect(caseFile.conclusionTitle == "Data needs checking")
    }

    @Test func evidenceProgressReflectsCollectedCaseEvidence() {
        let caseFile = LabCaseFile.sampleReady

        #expect(caseFile.evidenceCompletion == 1.0)
        #expect(caseFile.evidenceItems.filter(\.isConfirmed).count == caseFile.evidenceItems.count)
        #expect(caseFile.unresolvedBlockers.isEmpty)
        #expect(caseFile.mentorGrade == .distinction)
    }

    @Test func incompleteCaseProducesBlockersAndRecommendation() {
        let caseFile = LabCaseFile()

        #expect(caseFile.evidenceCompletion < 0.5)
        #expect(!caseFile.unresolvedBlockers.isEmpty)
        #expect(caseFile.nextRecommendation.contains("Start"))
        #expect(caseFile.mentorGrade == .incomplete)
    }

    @Test func suspiciousYieldReceivesDataGradePenalty() {
        var caseFile = LabCaseFile.sampleReady
        caseFile.yieldRecord = YieldRecord(percent: 124, diagnosis: .suspicious)

        #expect(caseFile.mentorGrade == .review)
        #expect(caseFile.unresolvedBlockers.contains { $0.title.contains("Yield") })
        #expect(caseFile.notebookConclusion.contains("above 100%"))
    }
}
