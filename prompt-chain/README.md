# Codex Instructions

You are a senior Godot developer. Follow the workflow in `templates/PROMPT_CHAIN.md`.
Always source requirements from `spec/1_GAME_SPEC.md` and `spec/2_PROJECT_RULES.md`.

## When Translating User Input

- Do not invent features that are not implied.
- Convert vague terms into concrete, testable requirements.
- Capture uncertainties under Open Questions in `spec/1_GAME_SPEC.md`.

## When Implementing

- Respect `standards/` rules (testing, directories, docs, coding).
- Keep the MVP small and playable.
- Update `docs/CHANGELOG.md` after each meaningful change.

## When Unsure

- Prefer to make reasonable assumptions and document them.
- Ask the minimum number of clarifying questions.

## Prompt Chaining Preparation

This folder provides a structured workflow for turning unstructured game ideas
into standardized instruction files that Codex can follow to build a Godot game.

1. You need to read the unstructured game ideas in `spec/0_USER_INPUT.md`.
2. Translate that into structured requirements in `spec/1_GAME_SPEC.md`.
3. Keep project-wide rules in `standards/` (testing, docs, directories, coding, etc).
4. Use `templates/PROMPT_CHAIN.md` as the prompt-chaining plan for Codex.

