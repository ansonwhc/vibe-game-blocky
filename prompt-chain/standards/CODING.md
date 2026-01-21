# Coding Standards (GDScript)

## Style
- Use GDScript 2.0 (Godot 4) syntax.
- Snake_case for variables and functions.
- PascalCase for class_name.
- Prefer small, focused scripts.

## Architecture
- Use scenes to compose gameplay objects.
- Autoloads for global state only when required.
- Keep UI logic separate from gameplay systems.

## Error Handling
- Fail fast with clear error messages.
- Avoid silent failures.

## Performance
- Avoid heavy logic in `_process` unless necessary.
- Use signals for event-driven behavior.
