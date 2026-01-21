# Directory Standards (Godot)

## Base Structure

- `scenes/` for .tscn files
- `scripts/` for .gd files
- `assets/` for art/audio
- `ui/` for UI scenes and scripts
- `autoload/` for singletons
- `tests/` for unit tests (if any)
- `docs/` for project documentation

## Conventions

- Use snake_case for filenames and node names.
- Keep scene names short and descriptive.
- Avoid deep nesting; prefer 2-3 levels max.

## New Feature Rule

When adding a feature, create its scene(s) and script(s) in the appropriate folder
and update `docs/CHANGELOG.md` with a short entry.
