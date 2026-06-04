# ChemVault Award Command Center Design

## Objective

Upgrade ChemVault from a polished linear learning app into an award-caliber interactive investigation: a live evidence command center follows the learner through the Grignard case, turns each decision into visible proof, and ends with a mentor-grade case report shaped by the learner's own choices.

This pass should make the app feel more advanced through continuity, responsiveness, and narrative intelligence rather than heavier decoration. The existing visual system stays, but the experience gains a stronger product spine.

## Direction Approved

Use the Evidence Command Center approach as the main implementation direction.

The app should still include the best parts of the other two directions:

- Molecular Cinema 2.0: mechanism scenes produce clear proof cards and stronger explanatory overlays.
- Mentor-Grade Final Artifact: the final notebook reads like a generated case report with rubric-style readiness.

## Audience And Award Fit

Primary audience: students preparing for organic chemistry practicals, exams, or pre-lab work.

Judging strengths this pass should emphasize:

- Creativity: organic chemistry becomes a case investigation instead of a static revision tool.
- Technical execution: shared state, dynamic case reports, responsive SwiftUI layouts, and performant animation choices.
- Educational value: safety, electron flow, misconceptions, and data interpretation are connected into one reasoning chain.
- Polish: the learner can see progress, evidence, and consequences across the whole app.

## Experience Concept

The learner is not simply moving through screens. They are building a case file.

The case:

"A Grignard reaction should form tert-butanol, but the isolated yield is suspicious. The learner must determine whether the failure comes from unsafe conditions, misunderstood mechanism, or experimental data quality."

Every major stage contributes evidence:

- Safety Scan records whether moisture risk was identified.
- Mission Briefing frames the question and shows the unresolved case.
- Mechanism Cinema records chemical proof from each scene.
- Mechanism Challenge records misconceptions, not just score.
- Data Check records yield quality and likely explanation.
- Notebook Summary synthesizes the final case status.

## Core Feature Set

### 1. Live Evidence Ledger

Add a reusable `EvidenceLedgerView` that can appear near the top of major screens.

It should show:

- case status
- safety evidence
- mechanism evidence count
- challenge status
- yield diagnosis
- readiness tint and icon

The ledger must be compact enough for mobile and visually strong enough to feel like a command center. It should use stable layout dimensions and avoid continuous animations.

### 2. Case Intelligence Model

Expand `LabCaseFile` with computed intelligence rather than adding a large view model.

Add derived values such as:

- evidence completion percentage
- collected evidence items
- unresolved blockers
- readiness score
- mentor grade
- strongest next recommendation

The model should remain value-based and testable. It should not introduce persistence, networking, or global services.

### 3. Mission Command Briefing

Upgrade `HomeView` and `LabMissionView` into a stronger command-center opening.

Changes:

- show case status instead of generic route cards
- add a "case hypothesis" panel
- show locked/unlocked evidence categories
- make the opening promise clear: "prove what happened before writing the notebook"

The home screen should immediately communicate the app's unique idea to a judge.

### 4. Mechanism Proof Cards

Mechanism Cinema already has the strongest visual identity. This pass should make it more purposeful.

Add a `MechanismProofCard` or strip that changes with the current scene:

- C-Mg polarity proves the nucleophilic carbon.
- O to Mg coordination explains carbonyl activation.
- HOMO to LUMO alignment explains why attack occurs.
- Curved arrows prove electron-pair movement.
- Magnesium alkoxide prevents drawing the alcohol too early.
- Acid workup explains final protonation.

This should be mostly textual/visual overlay work, not a 3D engine rewrite.

### 5. Data Diagnosis Upgrade

Make `DataCheckView` feel like a forensic result instead of a calculator.

Add:

- a compact evidence-linked explanation
- yield quality bands
- "most likely explanation" based on current `YieldDiagnosis`
- connection back to moisture and mechanism errors

Invalid input must remain safe and clear.

### 6. Mentor-Grade Notebook

Upgrade `LabNotebookSummaryView` into a final artifact.

Add:

- case verdict
- mentor grade
- evidence chain timeline
- unresolved blockers list
- recommended revision action
- notebook-ready conclusion text generated from `LabCaseFile`

The final screen should make the learner feel they produced something tangible and personalized.

## Data Flow

Keep the current stage-based `ContentView` navigation.

`ContentView` continues owning:

- `stage`
- `transitionID`
- `caseFile`

New data flow:

- Pass `caseFile` read-only into screens that display ledger context.
- Keep child updates as small completion closures where possible.
- Avoid broad two-way bindings unless a screen needs live mutation.

Recommended call shape:

- `HomeView(caseFile:onStart:)`
- `LabMissionView(caseFile:onBegin:)`
- `MechanismExplorerView(caseFile:onComplete:)`
- `DataCheckView(caseFile:onComplete:)`
- `LabNotebookSummaryView(caseFile:onRestart:)`

`SafetyScanView` and `MechanismChallengeView` can stay completion-driven because their result is only committed at submit time.

## Visual System

Use the current dark glass chemistry style.

Add a stronger case-system layer:

- command center panels
- evidence chips
- proof cards
- timeline rails
- readiness meters

Color semantics:

- accent amber: active investigation
- green: confirmed evidence
- blue/cyan: mechanism proof
- orange/red: risk, blocker, suspicious data
- neutral white opacity: unresolved or locked evidence

Performance rule:

No new repeating animations. Any animation should be one-shot, input-driven, or transition-based.

## Components

Likely new files:

- `EvidenceLedgerView.swift`
- `CaseTimelineView.swift`
- `MentorGradeView.swift`

Likely edited files:

- `LabCaseFile.swift`
- `ContentView.swift`
- `HomeView.swift`
- `LabMissionView.swift`
- `MechanismExplorerView.swift`
- `DataCheckView.swift`
- `LabNotebookSummaryView.swift`
- `LabCaseFileTests.swift`

Avoid editing the large mechanism theatre files unless a proof overlay requires it.

## Edge Cases

- A learner can reach the notebook with incomplete or weak evidence.
- If safety is missed, the notebook should warn rather than fail.
- If challenge misconceptions exist, the report should name them and suggest revision.
- If yield is above 100%, the app should classify data as suspicious and explain likely impurity or wet product.
- If yield input is invalid, the ledger should show data as incomplete.

## Testing

Add or extend pure model tests for:

- evidence completion percentage
- mentor grade/readiness score
- blocker generation
- suspicious yield behavior
- ready case behavior

Run:

```bash
xcodebuild -quiet build-for-testing -project ChemVaultLabCompanion.xcodeproj -scheme ChemVaultLabCompanion -destination 'platform=iOS Simulator,name=iPhone 17' -skip-testing:ChemVaultLabCompanionUITests
```

Also do a code scan for:

- no new `repeatForever`
- no old `onChange(of:perform:)` signatures
- no tracked `.superpowers/` browser companion files

## Out Of Scope

- No accounts, cloud sync, or backend.
- No persistent save system in this pass.
- No full reaction library.
- No new chemistry engine.
- No heavy continuous particle effects.
- No broad rewrite of all mechanism theatre variants.

## Success Criteria

The upgraded app should be explainable as:

"ChemVault is an organic chemistry case command center: students collect safety, mechanism, and data evidence, then generate a personalized notebook verdict."

The final build is successful when:

- the first screen immediately feels like a premium case investigation
- each major stage visibly contributes to one evidence chain
- the final notebook is personalized by the learner's decisions
- the UI feels richer without reintroducing lag
- the project remains buildable and test-covered for the new model logic
