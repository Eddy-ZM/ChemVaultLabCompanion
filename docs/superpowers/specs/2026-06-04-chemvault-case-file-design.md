# ChemVault Case File Design

## Objective

Transform ChemVault from a sequence of chemistry screens into a polished Swift Student Challenge experience: an interactive pre-lab case file where the learner investigates a low-yield Grignard reaction, explains the invisible mechanism, and leaves with a mentor-quality lab notebook.

The strongest direction is a hybrid of:

- Laboratory mystery: the learner investigates why a Grignard reaction might fail.
- Mentor notebook: every decision becomes evidence in a final academic summary.

The app should feel advanced because the experience has continuity, not because every screen has more decoration.

## Audience And Judging Fit

Primary audience: students preparing for an organic chemistry practical or exam.

Judging strengths to highlight:

- Creativity: chemistry is presented as an interactive case investigation.
- Technical execution: animated SwiftUI mechanism cinema, stateful choices, responsive layouts.
- Educational value: safety, electron flow, intermediates, workup, and yield interpretation are connected.
- Polish: cinematic pacing, accessible controls, clear feedback, and a coherent final artifact.

## Experience Narrative

The learner opens a "Pre-Lab Case File" about a Grignard addition that produced a lower-than-expected yield. The app frames the task as a diagnosis:

1. What conditions could destroy the reagent before reaction?
2. What does the mechanism prove about the reactive sites?
3. Which misconceptions would lead to the wrong product or intermediate?
4. What does the yield suggest about the experiment?
5. What should the learner write in their notebook before entering the real lab?

The current linear stage flow remains, but every stage should feel like a chapter in one case rather than a separate mini-app.

## Core Product Changes

### 1. Shared Case File State

Add a small app-owned value model that stores the learner's case progress:

- safety diagnosis result
- selected risk factors
- mechanism challenge score and misconception notes
- calculated yield
- yield interpretation category
- final readiness level

`ContentView` owns this state and passes bindings or update closures to child views. This keeps the current simple stage navigation while allowing later screens to reflect earlier choices.

### 2. Mission Briefing Upgrade

Reframe `LabMissionView` as an incident briefing:

- case title: "Case 04: The Vanishing Grignard Yield"
- short scenario: acetone + methylmagnesium bromide should form tert-butanol, but the isolated yield is suspicious
- evidence strip: dry glassware, polar C-Mg bond, carbonyl activation, alkoxide intermediate, yield evidence
- objective cards remain interactive, but their copy should sound like investigation goals

### 3. Safety Scan Upgrade

Replace the current single yes/no question with a compact diagnosis panel:

- learner selects likely risk factors from 3-4 cards
- the correct finding is moisture/wet glassware
- immediate feedback explains the chemical consequence
- state records whether the learner identified the moisture risk

The UI should still be quick. This screen is about earning the right to start the mechanism, not becoming a long quiz.

### 4. Mechanism Cinema Continuity

Keep the existing `MechanismExplorerView` and mechanism cinema as the technical centerpiece. Add a case file strip or compact "Evidence collected" panel that updates as scenes progress:

- C-Mg polarity explains nucleophilic carbon
- O to Mg coordination explains activation
- curved arrows explain conservation of electron pairs
- alkoxide before alcohol prevents a common student error

This gives the animation story purpose and makes the learner feel they are collecting evidence.

### 5. Challenge Feedback As Misconception Diagnosis

Keep the current mechanism challenge structure, but record more than a score:

- if the learner misses nucleophile, record "reactive-site misconception"
- if they miss electron flow, record "arrow-pushing misconception"
- if they miss intermediate, record "workup timing misconception"
- if they miss workup, record "protonation misconception"

The final notebook can then say what the learner handled well and what they should revise.

### 6. Data Diagnosis Upgrade

Keep editable actual/theoretical mass inputs, but make the screen a diagnosis:

- classify yield as low, reasonable, high, or impossible
- connect the classification to earlier case evidence
- show a short "most likely explanation" card
- pass yield and interpretation back to the shared case file

For the default values, the app should show a plausible reduced yield and explain that moisture, incomplete reaction, transfer loss, or purification loss are possible.

### 7. Final Lab Notebook

Upgrade `LabNotebookSummaryView` into a case report generated from accumulated state:

- Case conclusion: ready / needs review / data suspicious
- Safety finding: whether moisture risk was identified
- Mechanism evidence: key points from the cinema
- Challenge diagnosis: score and misconception notes
- Yield diagnosis: calculated percentage and interpretation
- Mentor note: one concise next-step recommendation

The final page should feel like the user's learning artifact, not a static congratulation screen.

## Visual Direction

Use the existing dark glass lab style, but introduce a stronger case-file identity:

- restrained amber accent remains for active chemistry/evidence
- green for confirmed findings
- red/orange only for risk or suspicious data
- cards become "evidence", "diagnosis", and "notebook" panels
- avoid adding more random glow effects; prioritize hierarchy and continuity

The first screen should make the project identity clear: ChemVault is a lab companion that turns invisible reaction logic into a case file.

## Architecture

Keep the current project shape and avoid a large rewrite.

Recommended additions:

- `LabCaseFile.swift`
  - `LabCaseFile`
  - `SafetyDiagnosis`
  - `YieldDiagnosis`
  - `MechanismMisconception`
  - computed readiness summary

Recommended edits:

- `ContentView.swift`
  - own `@State private var caseFile`
  - pass update closures into safety, challenge, data, and notebook screens
- `LabMissionView.swift`
  - copy and layout upgrade only
- `SafetyScanView.swift`
  - replace yes/no with risk-factor selection
- `MechanismChallengeView.swift`
  - report score and missed concepts on completion
- `DataCheckView.swift`
  - report calculated yield and diagnosis on completion
- `LabNotebookSummaryView.swift`
  - render dynamic case report from `LabCaseFile`

This keeps screen responsibilities clear and preserves existing visual components.

## State Flow

`ContentView` owns one `LabCaseFile`.

Each stage writes a small result:

- Safety scan updates safety finding.
- Mechanism challenge updates score and misconceptions.
- Data check updates yield value and diagnosis.
- Notebook reads the full case file.

Navigation remains stage-based for now. A full router is unnecessary for this scope.

## Error Handling And Edge Cases

- Invalid mass input should not crash or generate a false conclusion.
- Yield above 100% should be treated as suspicious data, not success.
- If the learner skips or misses a concept, the notebook should phrase feedback constructively.
- Compact screens must keep bottom action bars from covering content.
- Animations should remain decorative and not block core interaction.

## Testing And Verification

Minimum verification:

- Build on iOS Simulator.
- Exercise default path from launch to notebook.
- Check invalid yield input behavior.
- Check low, reasonable, high, and above-100 yield categories.
- Confirm final notebook changes when challenge answers are wrong.

Targeted tests:

- Add pure Swift tests for `LabCaseFile` readiness and `YieldDiagnosis` classification if the existing test target can compile them without major project changes.

## Out Of Scope

- No backend, accounts, or persistent storage.
- No full game economy, badges, or leaderboard.
- No 3D chemistry engine rewrite.
- No multiple reaction library in this pass.
- No unrelated visual redesign of every component.

## Success Criteria

The improved app should be describable in one sentence:

"ChemVault turns a Grignard pre-lab into an interactive case file where students diagnose safety risks, watch the mechanism, test their reasoning, interpret yield, and generate a notebook-ready explanation."

When the app reaches the final screen, the learner should see evidence that their own choices shaped the report.
