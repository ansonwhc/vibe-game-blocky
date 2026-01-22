# Project README

## Overview

- Game title: Blocky Roll
- One-line pitch: Roll a rectangular block across floating tile grids, toggling switches and bridges to reach the goal hole.

## Setup

- Godot version: 4.5.1.stable.official
- Open project in Godot and press Play.

## Build Notes

- Install export templates in Godot: `Editor > Manage Export Templates > Download and Install`.
- Create presets in `Project > Export` for each target platform (Windows/macOS/Linux/Web).
- Set the main scene and icon, then `Export Project` to get a standalone build that runs without Godot installed.
- For Windows: export `.exe` + `.pck`. For macOS: export `.zip` app bundle. For Linux: export `.x86_64` + `.pck`. For Web: export `.html` + `.wasm` + `.pck`.
- Starter presets live in `export_presets.cfg` (adjust in Godot if you need different names, icons, or bundle IDs).

## Web Export Tips

- Use the `Web` preset and export to `export/web/index.html`.
- If you enable threads, host with COOP/COEP headers; otherwise keep threads off for simple static hosting.
- Enable gzip or brotli for `.html`, `.js`, `.wasm`, and `.pck` on your web server to reduce load time.

## Roadmap

- Implement grid + block movement with upright/flat orientation logic.
- Add core tile types (goal, weak, switches, bridges, buttons, teleporters).
- Build three MVP levels and a simple level loader.
- Create basic UI (start menu, pause, level indicator, reset).
- Add minimal SFX and test the core loop.

## Directory Plan

- `scenes/` for main, level, block, tile, and menu scenes
- `scripts/` for grid, block controller, level manager, tile behaviors
- `ui/` for HUD and menus
- `assets/` for placeholder meshes and audio
