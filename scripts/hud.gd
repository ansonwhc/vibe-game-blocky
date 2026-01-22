extends Control

@onready var level_label: Label = $Margin/VBox/LevelLabel
@onready var move_label: Label = $Margin/VBox/MoveLabel
@onready var split_label: Label = $Margin/VBox/SplitLabel
@onready var hint_label: Label = $Margin/VBox/HintLabel
@onready var status_label: Label = $StatusLabel

func set_level_info(level_name: String, level_index: int, total_levels: int) -> void:
	level_label.text = "Level %d/%d: %s" % [level_index, total_levels, level_name]

func set_move_count(count: int) -> void:
	move_label.text = "Moves: %d" % count

func set_split_state(is_split: bool, active_half: int) -> void:
	if is_split:
		split_label.text = "Split: Active Half %d" % (active_half + 1)
	else:
		split_label.text = ""

func show_status(text: String, duration: float = 1.0) -> void:
	status_label.text = text
	if duration <= 0.0:
		return
	await get_tree().create_timer(duration).timeout
	status_label.text = ""
