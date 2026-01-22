# Project Rules (LLM Output if not specified, otherwise User Editable)

Use this file to define constraints and priorities that are not captured in GAME_SPEC.

## Must Have

- Grid-based block rolling with upright/flat orientation logic.
- Tile types: normal, goal hole, weak, switch-controlled bridges, button-toggled tiles, teleporters.
- Three handcrafted MVP levels: basic movement, switches/bridges, teleporters/split control.
- Level reset and pause menu.

## Must Avoid

- Combat, enemies, or damage systems.
- Physics-driven free movement (no sliding or analog drift).
- Procedural generation.
- Complex UI systems (inventory, stats, economy).

## Nice To Have

- Move counter or timer.
- Undo/rewind.
- Level completion ratings or stars.
- Extra visual polish for tile transitions.

## Content Limits

- Total scenes max: 10
- Total scripts max: 12
- Art/audio placeholders allowed: Yes (primitive shapes + placeholder SFX)

## Technical Choices

- Godot version: 4.5.1.stable.official
- Use addons: None
