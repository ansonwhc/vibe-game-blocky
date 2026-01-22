# Changelog

## Unreleased

- Answer open questions in `prompt-chain/spec/1_GAME_SPEC.md` with concrete MVP decisions.
- Define MVP scope and constraints in `prompt-chain/spec/2_PROJECT_RULES.md`.
- Document project overview and plan in `docs/README.md`.
- Build MVP gameplay loop with grid movement, tile interactions, and three levels.
- Add main menu, HUD, and pause UI plus runtime input mappings.
- Wire main scene and project settings; document controls.
- Add move counter to the HUD and track moves per level.
- Polish visuals with prototype mini bundle textures for tiles and block.
- Document prototype mini bundle usage in `prompt-chain/spec/2_PROJECT_RULES.md`.
- Render the block as a single mesh when not split and animate rolls with rotation.
- Restore distinct tile and block colors for readability.
- Keep trigger tile colors consistent across levels and split near teleporter in level 3.
- Treat level 1 goal as a hole and play a fall animation on completion.
- Revert level 1 to a standard goal tile with no holes in the floor.
- Keep the block standing on the goal tile when completing a level.
- Tests: `godot --headless --quit` (pass with escalated; sandbox run crashed with Signal 6).
