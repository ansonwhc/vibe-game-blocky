# Prompt Chain

Each stage produces or updates a file.
Keep outputs brief and file-based. Ask clarifying questions only if needed.
Run incremental tests (Godot CLI or GUT) before moving to the next stage when code or gameplay behavior changes.

## Stage 0: Intake

Goal: Capture unstructured request.
Input: User natural language.
Action: Paste into `spec/0_USER_INPUT.md`.
Output: Updated `spec/0_USER_INPUT.md`.

## Stage 1: Normalize

Goal: Convert raw input into structured requirements.
Input: `spec/0_USER_INPUT.md`.
Action: Fill `spec/1_GAME_SPEC.md` and list open questions.
Output: Updated `spec/1_GAME_SPEC.md`.

## Stage 2: Scoping

Goal: Define MVP scope and technical boundaries.
Input: `spec/1_GAME_SPEC.md`, `spec/2_PROJECT_RULES.md`.
Action: Identify MVP features, defer nice-to-haves.
Output: Update `spec/2_PROJECT_RULES.md` and `docs/CHANGELOG.md`.

## Stage 3: Build Plan

Goal: Create a minimal implementation plan.
Input: GAME_SPEC + standards in `standards/`.
Action: Produce a short task list and directory layout.
Output: Update `docs/README.md` with setup and plan.

## Stage 4: Implementation

Goal: Implement gameplay and UI.
Input: GAME_SPEC + standards.
Action: Create scenes/scripts/assets within the directory rules.
Output: Code and scene files; update docs.
Gate: Run relevant tests (Godot CLI or GUT) before proceeding.

## Stage 5: Test

Goal: Verify core loop.
Input: `standards/TESTING.md`.
Action: Run manual checks; note failures.
Output: Update `docs/CHANGELOG.md` with test notes.
Gate: If any test fails, fix and re-run before moving on.

## Stage 6: Polish

Goal: Tuning, UX improvements, cleanup.
Input: Test results + feedback.
Action: Adjust balance and UX; update docs.
Output: Updated files and changelog.
Gate: Run incremental tests (Godot CLI or GUT) before finishing.
