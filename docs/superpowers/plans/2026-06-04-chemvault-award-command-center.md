# ChemVault Award Command Center Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a live evidence command center across ChemVault so the learner's safety, mechanism, challenge, and yield decisions produce a personalized mentor-grade notebook verdict.

**Architecture:** Keep the current stage-based SwiftUI flow. Extend the existing value-based `LabCaseFile` with pure computed intelligence, add focused reusable presentation components, and pass the case file read-only into screens that need ledger context.

**Tech Stack:** Swift 5, SwiftUI, Swift Testing, existing Xcode iOS app target.

---

## File Structure

- Modify `ChemVaultLabCompanion/LabCaseFile.swift`: add `CaseEvidenceItem`, `CaseBlocker`, `MentorGrade`, readiness score, evidence percentage, verdict copy, and recommendation copy.
- Create `ChemVaultLabCompanion/EvidenceLedgerView.swift`: compact live command-center panel and small evidence chips.
- Create `ChemVaultLabCompanion/CaseTimelineView.swift`: final notebook evidence chain timeline.
- Create `ChemVaultLabCompanion/MentorGradeView.swift`: reusable grade badge and readiness score display.
- Modify `ChemVaultLabCompanion/ContentView.swift`: pass `caseFile` into the screens that show context.
- Modify `ChemVaultLabCompanion/HomeView.swift`: replace generic route cards with command-center opening and case hypothesis.
- Modify `ChemVaultLabCompanion/LabMissionView.swift`: show live ledger and stronger investigation briefing.
- Modify `ChemVaultLabCompanion/MechanismExplorerView.swift`: show ledger and current-scene mechanism proof card.
- Modify `ChemVaultLabCompanion/DataCheckView.swift`: show ledger and forensic diagnosis bands.
- Modify `ChemVaultLabCompanion/LabNotebookSummaryView.swift`: render mentor grade, evidence timeline, blockers, and generated conclusion.
- Modify `ChemVaultLabCompanionTests/LabCaseFileTests.swift`: add pure model tests for the new intelligence.

## Task 1: Case Intelligence Model

**Files:**
- Modify: `ChemVaultLabCompanion/LabCaseFile.swift`
- Test: `ChemVaultLabCompanionTests/LabCaseFileTests.swift`

- [ ] **Step 1: Add failing model tests**

Add tests that assert:

```swift
@Test func evidenceProgressReflectsCollectedCaseEvidence() {
    var caseFile = LabCaseFile.sampleReady
    #expect(caseFile.evidenceCompletion == 1.0)
    #expect(caseFile.evidenceItems.filter(\.isConfirmed).count == caseFile.evidenceItems.count)
    #expect(caseFile.unresolvedBlockers.isEmpty)
}

@Test func incompleteCaseProducesBlockersAndRecommendation() {
    let caseFile = LabCaseFile()
    #expect(caseFile.evidenceCompletion < 0.5)
    #expect(!caseFile.unresolvedBlockers.isEmpty)
    #expect(caseFile.nextRecommendation.contains("Start"))
}

@Test func suspiciousYieldReceivesDataGradePenalty() {
    var caseFile = LabCaseFile.sampleReady
    caseFile.yieldRecord = YieldRecord(percent: 124, diagnosis: .suspicious)
    #expect(caseFile.mentorGrade == .review)
    #expect(caseFile.unresolvedBlockers.contains { $0.title.contains("Yield") })
}
```

- [ ] **Step 2: Run test build to confirm current model lacks these APIs**

Run:

```bash
xcodebuild -quiet build-for-testing -project ChemVaultLabCompanion.xcodeproj -scheme ChemVaultLabCompanion -destination 'platform=iOS Simulator,name=iPhone 17' -skip-testing:ChemVaultLabCompanionUITests
```

Expected: compile failure until the new model APIs exist.

- [ ] **Step 3: Implement pure computed model APIs**

Add lightweight value types and computed properties:

```swift
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

enum MentorGrade: String, Equatable {
    case distinction = "A"
    case strong = "B+"
    case review = "C"
    case incomplete = "In progress"
}
```

Then add deterministic computed properties on `LabCaseFile` for `evidenceItems`, `evidenceCompletion`, `unresolvedBlockers`, `readinessScore`, `mentorGrade`, `nextRecommendation`, and `notebookConclusion`.

- [ ] **Step 4: Re-run test build**

Expected: tests compile and app target compiles.

## Task 2: Reusable Command Center Components

**Files:**
- Create: `ChemVaultLabCompanion/EvidenceLedgerView.swift`
- Create: `ChemVaultLabCompanion/CaseTimelineView.swift`
- Create: `ChemVaultLabCompanion/MentorGradeView.swift`

- [ ] **Step 1: Create `EvidenceLedgerView`**

Build a compact SwiftUI panel:

```swift
struct EvidenceLedgerView: View {
    let caseFile: LabCaseFile
    let compact: Bool
}
```

It should render a status header, completion percentage, and a responsive grid of evidence chips. It must use only static layout and input-driven transitions.

- [ ] **Step 2: Create `CaseTimelineView`**

Build a final-report timeline:

```swift
struct CaseTimelineView: View {
    let items: [CaseEvidenceItem]
    let compact: Bool
}
```

Confirmed items use stronger color and checkmark icon; unconfirmed items are visually locked or dimmed.

- [ ] **Step 3: Create `MentorGradeView`**

Build a reusable grade badge:

```swift
struct MentorGradeView: View {
    let caseFile: LabCaseFile
    let compact: Bool
}
```

It should show grade, readiness score, and next recommendation without adding continuous animation.

## Task 3: Integrate Ledger Into Main Flow

**Files:**
- Modify: `ChemVaultLabCompanion/ContentView.swift`
- Modify: `ChemVaultLabCompanion/HomeView.swift`
- Modify: `ChemVaultLabCompanion/LabMissionView.swift`
- Modify: `ChemVaultLabCompanion/MechanismExplorerView.swift`
- Modify: `ChemVaultLabCompanion/DataCheckView.swift`

- [ ] **Step 1: Pass case file into screens**

Update call sites to:

```swift
HomeView(caseFile: caseFile) { ... }
LabMissionView(caseFile: caseFile) { ... }
MechanismExplorerView(caseFile: caseFile) { ... }
DataCheckView(caseFile: caseFile) { record in ... }
```

- [ ] **Step 2: Upgrade Home opening**

Add command-center positioning with `EvidenceLedgerView`, case hypothesis, and evidence categories. Keep the start button visible and avoid nested card-heavy layout.

- [ ] **Step 3: Upgrade Mission briefing**

Add `EvidenceLedgerView` after the hero and rewrite the briefing as an incident command brief. Keep objective cards interactive.

- [ ] **Step 4: Add Mechanism proof card**

Add a proof card derived from `currentCinemaStep` showing proof title, chemical meaning, and notebook implication.

- [ ] **Step 5: Upgrade Data diagnosis**

Add `EvidenceLedgerView`, yield bands, and a case-linked explanation that responds to `YieldDiagnosis`.

## Task 4: Mentor-Grade Final Report

**Files:**
- Modify: `ChemVaultLabCompanion/LabNotebookSummaryView.swift`
- Test: `ChemVaultLabCompanionTests/LabCaseFileTests.swift`

- [ ] **Step 1: Add mentor grade to completion hero**

Render `MentorGradeView` near the top of the report.

- [ ] **Step 2: Add evidence chain timeline**

Render `CaseTimelineView(items: caseFile.evidenceItems, compact: compact)`.

- [ ] **Step 3: Add unresolved blockers panel**

If `caseFile.unresolvedBlockers` is empty, show a confirmed-readiness panel. Otherwise, show blocker rows with actionable revision copy.

- [ ] **Step 4: Add generated conclusion**

Show `caseFile.notebookConclusion` as a notebook-ready paragraph that changes for ready, review, suspicious-data, and incomplete states.

## Task 5: Verification, Commit, Push

**Files:**
- Verify all modified files.

- [ ] **Step 1: Scan for performance regressions**

Run:

```bash
rg -n "repeatForever|\\.onChange\\(of:.*\\) \\{ [^_,]" ChemVaultLabCompanion || true
```

Expected: no matches.

- [ ] **Step 2: Build for testing**

Run:

```bash
xcodebuild -quiet build-for-testing -project ChemVaultLabCompanion.xcodeproj -scheme ChemVaultLabCompanion -destination 'platform=iOS Simulator,name=iPhone 17' -skip-testing:ChemVaultLabCompanionUITests
```

Expected: build succeeds.

- [ ] **Step 3: Confirm git hygiene**

Run:

```bash
git status --short
git diff --check
git ls-files | rg '\\.superpowers|xcuserdata|xcuserstate' || true
```

Expected: no tracked companion or Xcode user-state files.

- [ ] **Step 4: Commit and push**

Commit implementation and push `main` to `origin/main` after verification passes.
