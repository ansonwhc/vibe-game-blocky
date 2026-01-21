# Testing Standards (Godot)

## Scope

Testing should verify core gameplay loop, controls, UI flow, and critical systems.
Use a minimal, repeatable checklist. Prefer in-editor playtests.

## Automated Tests (Default)

If unit tests are added:

- Use GUT or Godot's built-in testing if already present.
- Provide commands to run tests in headless mode.
- launch game without errors

## Manual Test Checklist (Less preferred)

- Launch game from editor without errors.
- Main menu loads and Start begins gameplay.
- Player can move, attack, and use abilities.
- Health/damage and death state work.
- One full loop of the core progression is playable.
- Pause menu works and can resume back to gameplay.
- No blocking errors in Output.

## Reporting

- Record any errors/warnings in a short note.
- If a test is skipped, state why.
