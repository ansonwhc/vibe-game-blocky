#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXPORT_DIR="$ROOT_DIR/export"

GODOT_BIN="${GODOT_BIN:-godot}"

mkdir -p \
  "$EXPORT_DIR/windows" \
  "$EXPORT_DIR/macos" \
  "$EXPORT_DIR/linux" \
  "$EXPORT_DIR/web"

"$GODOT_BIN" --headless --path "$ROOT_DIR" --export-release "Windows Desktop" "$EXPORT_DIR/windows/VibeGameTetris.exe"
# "$GODOT_BIN" --headless --path "$ROOT_DIR" --export-release "macOS" "$EXPORT_DIR/macos/VibeGameTetris.zip"
"$GODOT_BIN" --headless --path "$ROOT_DIR" --export-release "Linux/X11" "$EXPORT_DIR/linux/VibeGameTetris.x86_64"
"$GODOT_BIN" --headless --path "$ROOT_DIR" --export-release "Web" "$EXPORT_DIR/web/index.html"
