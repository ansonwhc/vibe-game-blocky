# Structured Game Spec (LLM Output)

Use this file to capture the structured interpretation of 0_USER_INPUT.md.
Keep sections concise and explicit. All gameplay requirements must be stated here.

## High-Level Summary

- Title: Blocky Roll
- Genre: 3D puzzle
- Target Platform: Desktop (Windows/macOS/Linux)
- Perspective/Camera: Fixed 3/4 isometric camera with slight tilt.
- Core Loop (one sentence): Roll a rectangular block across a floating tile grid, trigger switches, and stand it upright on the goal hole to clear each level.

## Player Experience Goals

- Methodical, low-stress puzzle solving with clear cause-and-effect.

## Controls

- Keyboard: Arrow keys/WASD to roll; R to reset level; Tab to switch active half when split; Esc to pause.
- Gamepad (optional): D-pad/left stick to roll; X/Y to switch active half; Start to pause; Select to reset.
- Mouse (optional): None.

## Core Mechanics

- Movement: Block rolls one tile at a time; orientation matters (flat vs upright).
- Combat: None
- Abilities: Teleporters split the block into two halves; player switches which half is active; halves merge when adjacent and aligned.
- Progression: Level-based; MVP has three handcrafted levels with increasing mechanics.
- Economy/Resources: None

## World/Level Design

- Level structure: Discrete floating grid of tiles with gaps, goal hole, switches, bridges, weak tiles, buttons, and teleporters.
- Procedural generation (if any): None
- Encounters: None
- Bosses: None

## Enemies

- Enemy archetypes: None
- Behaviors: None

## Items/Powerups

- Item types: None
- Acquisition: None
- Balance notes: None

## UI/UX

- HUD elements: Level number/name, active half indicator when split, reset hint.
- Menus: Simple start screen with level select; pause menu with resume/restart/quit.
- Feedback (VFX/SFX): Tile state color changes, switch/bridge toggle cues, falling/goal effects, clear audio feedback.

## Art Direction

- Visual style: Minimalist low-poly block and tile grid floating in space.
- Color palette: Neutral gray base with accent colors (green goal, orange weak, blue teleporter, red switches).
- References: Bloxorz

## Audio Direction

- Music: Subtle ambient loop.
- SFX: Roll thud, switch click, teleport whoosh, fall, goal chime.

## Technical Constraints

- Performance targets: 60 fps on mid-range desktop.
- Resolution/aspect: 1280x720 minimum, scale to window.
- Input remapping: Not in MVP.
- Godot version: 4.5.1.stable.official

## Acceptance Criteria

- Player can roll a rectangular block across a grid of tiles using directional input.
- Block can be in flat or upright orientation; orientation affects interactions.
- Level completes only when the block is upright on the goal hole tile.
- Block falls off the level if it moves beyond the edge of the grid.
- Weak tiles drop the block when it stands upright on them.
- Switches can open or close bridges that affect traversable tiles.
- Buttons can toggle tile states as part of puzzles.
- Teleporters split the block into two halves that can be moved separately.
- Player can switch the active half; halves merge when adjacent and aligned.
- Player can reset the current level.

## Open Questions

- None.
