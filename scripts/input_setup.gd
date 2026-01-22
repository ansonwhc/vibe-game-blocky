extends Node
class_name InputSetup

static func ensure_actions() -> void:
	_add_action("move_up", [KEY_W, KEY_UP], [JOY_BUTTON_DPAD_UP])
	_add_action("move_down", [KEY_S, KEY_DOWN], [JOY_BUTTON_DPAD_DOWN])
	_add_action("move_left", [KEY_A, KEY_LEFT], [JOY_BUTTON_DPAD_LEFT])
	_add_action("move_right", [KEY_D, KEY_RIGHT], [JOY_BUTTON_DPAD_RIGHT])
	_add_action("reset_level", [KEY_R], [JOY_BUTTON_BACK])
	_add_action("switch_half", [KEY_TAB], [JOY_BUTTON_X])
	_add_action("pause_game", [KEY_ESCAPE], [JOY_BUTTON_START])

static func _add_action(action_name: String, keycodes: Array, buttons: Array) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	if InputMap.action_get_events(action_name).is_empty():
		for keycode in keycodes:
			var key_event := InputEventKey.new()
			key_event.keycode = keycode
			InputMap.action_add_event(action_name, key_event)
		for button in buttons:
			var button_event := InputEventJoypadButton.new()
			button_event.button_index = button
			InputMap.action_add_event(action_name, button_event)
