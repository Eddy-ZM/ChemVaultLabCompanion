# Living Chemistry Components Design

## Goal

Make each screen feel alive with chemistry-specific opening components, using the same one-shot atom rotation language as the launch screen without adding continuous animation cost.

## Approved Direction

The app should stop relying only on page fades. Each major stage gets a small animated chemical object or diagnostic state cue:

- Home: orbital atom badge and scanned dossier rows.
- Mission: flask badge with rising reagent fill and animated mission cards.
- Safety: scan sweep across risk cards and a diagnostic seal after submission.
- Mechanism: proof cards and the mechanism header use orbital/electron-motion cues so attention lands on the current proof.
- Challenge: answers reveal correct reasoning with a proof-unlock/stamp animation.
- Data: yield gauge keeps its progress animation, while the diagnosis receives a seal and active band sweep.
- Notebook: the final verdict appears as a stamped seal, with report rows revealed as evidence cards.

## Architecture

Add a small reusable animation layer instead of embedding custom state machines in every screen:

- `ChemistryMotionPreset` defines deterministic animation budgets for tests and future review.
- `AnimatedAtomBadge`, `AnimatedFlaskBadge`, `DiagnosticSeal`, `ProofUnlockBanner`, and scan modifiers provide page-specific cues.
- Existing views keep their data ownership. Animation state stays local inside the visual components.

## Performance Rules

- No `repeatForever`.
- Component animations are one-shot on appear or one-shot when a selected state changes.
- Durations stay at or below 1.6 seconds.
- No timers, no canvas loops, and no layout-changing text animations.

## Testing

Unit tests verify the shared animation presets stay one-shot and lightweight. Full app verification uses simulator build and the existing unit test target.
