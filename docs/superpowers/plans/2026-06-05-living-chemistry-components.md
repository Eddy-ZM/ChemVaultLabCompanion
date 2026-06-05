# Living Chemistry Components Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add award-level, chemistry-specific component animations to each app stage while keeping animation work one-shot and lightweight.

**Architecture:** Introduce a reusable SwiftUI animation component file with tested motion presets. Integrate the components into existing screen views without changing app routing or domain state.

**Tech Stack:** SwiftUI, Swift Testing, XcodeBuildMCP simulator build/test.

---

### Task 1: Lock The Motion Budget

**Files:**
- Create: `ChemVaultLabCompanionTests/ChemistryMotionPresetTests.swift`
- Create: `ChemVaultLabCompanion/AnimatedChemistryComponents.swift`

- [x] **Step 1: Write the failing tests**

```swift
@Test func livingChemistryAnimationsStayOneShotAndLightweight() {
    for preset in ChemistryMotionPreset.allCases {
        #expect(preset.repeats == false)
        #expect(preset.duration <= 1.6)
        #expect(preset.maximumTravel <= 160)
    }
}
```

- [x] **Step 2: Run the tests and verify red**

Run:

```bash
xcodebuild test -only-testing:ChemVaultLabCompanionTests/ChemistryMotionPresetTests
```

Expected: compile failure because `ChemistryMotionPreset` does not exist yet.

- [x] **Step 3: Implement the preset enum and visual components**

Create `AnimatedChemistryComponents.swift` with:

- `ChemistryMotionPreset`
- `AnimatedAtomBadge`
- `AnimatedFlaskBadge`
- `DiagnosticSeal`
- `ProofUnlockBanner`
- `scanSweep(active:tint:cornerRadius:)`

- [x] **Step 4: Verify the preset tests pass**

Run the same test target and expect all preset tests to pass.

### Task 2: Integrate Per-Screen Component Choreography

**Files:**
- Modify: `ChemVaultLabCompanion/HomeView.swift`
- Modify: `ChemVaultLabCompanion/LabMissionView.swift`
- Modify: `ChemVaultLabCompanion/SafetyScanView.swift`
- Modify: `ChemVaultLabCompanion/MechanismExplorerView.swift`
- Modify: `ChemVaultLabCompanion/MechanismChallengeView.swift`
- Modify: `ChemVaultLabCompanion/DataCheckView.swift`
- Modify: `ChemVaultLabCompanion/LabNotebookSummaryView.swift`

- [x] **Step 1: Replace static hero badges**

Use `AnimatedAtomBadge` and `AnimatedFlaskBadge` in the screen headers.

- [x] **Step 2: Add scan and seal cues**

Apply `scanSweep` to selected/active cards and `DiagnosticSeal` to feedback or verdict states.

- [x] **Step 3: Add proof unlock feedback**

Use `ProofUnlockBanner` in the mechanism proof card and challenge feedback.

### Task 3: Verify And Ship

**Files:**
- Verify all changed Swift files.

- [x] **Step 1: Run focused tests**

Run the new preset tests and existing model tests.

- [x] **Step 2: Run simulator build**

Run simulator build for `ChemVaultLabCompanion`.

- [x] **Step 3: Static performance scan**

Search for accidental `repeatForever` additions and old one-argument `onChange` usage.

- [ ] **Step 4: Commit and push**

Commit all scoped changes and push `main` to `origin`.
