extends Control

signal level_selected(level_index: int)

@onready var level_buttons: VBoxContainer = $Menu/LevelButtons

func build_menu(levels: Array) -> void:
	for child in level_buttons.get_children():
		child.queue_free()
	for i in range(levels.size()):
		var button := Button.new()
		var level_name = levels[i].get("name", "Level %d" % (i + 1))
		button.text = "Level %d: %s" % [i + 1, level_name]
		button.pressed.connect(_on_level_pressed.bind(i))
		level_buttons.add_child(button)

func _on_level_pressed(index: int) -> void:
	emit_signal("level_selected", index)
