# Testing Standards (Godot)

## Scope

Testing should verify core gameplay loop, controls, UI flow, and critical systems.
Use a minimal, repeatable checklist. Prefer in-editor playtests.
Run tests incrementally after each meaningful change before proceeding to the next stage.

## Automated Tests (Default)

If unit tests are added:

- Use GUT or Godot's built-in testing if already present.
- Provide commands to run tests in headless mode.
- launch game without errors
- Prefer the Godot CLI or GUT CLI for repeatable runs before moving on.

### Example Commands

- Godot CLI smoke test: `godot --headless --quit`
- GUT (installed under {PROJECT_ROOT}/addons/): `godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests`

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
