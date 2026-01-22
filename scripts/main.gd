extends Node

@onready var game_manager: GameManager = $World
@onready var main_menu: Control = $CanvasLayer/MainMenu
@onready var hud: Control = $CanvasLayer/Hud
@onready var pause_menu: Control = $CanvasLayer/PauseMenu

var levels: Array = []
var in_game := false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	InputSetup.ensure_actions()
	levels = LevelData.get_levels()
	main_menu.build_menu(levels)
	main_menu.level_selected.connect(_on_level_selected)
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.resume_pressed.connect(_on_resume_pressed)
	pause_menu.restart_pressed.connect(_on_restart_pressed)
	pause_menu.quit_to_menu_pressed.connect(_on_quit_to_menu_pressed)
	game_manager.level_loaded.connect(_on_level_loaded)
	game_manager.split_state_changed.connect(_on_split_state_changed)
	game_manager.move_count_changed.connect(_on_move_count_changed)
	game_manager.level_completed.connect(_on_level_completed)
	game_manager.level_failed.connect(_on_level_failed)
	_show_main_menu()

func _process(_delta: float) -> void:
	if in_game and not get_tree().paused:
		game_manager.process_input()
	if in_game and Input.is_action_just_pressed("pause_game"):
		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()

func _on_level_selected(level_index: int) -> void:
	_start_level(level_index)

func _start_level(level_index: int) -> void:
	in_game = true
	main_menu.hide()
	pause_menu.hide()
	hud.show()
	get_tree().paused = false
	game_manager.start_level(level_index)

func _show_main_menu() -> void:
	in_game = false
	get_tree().paused = false
	main_menu.show()
	pause_menu.hide()
	hud.hide()

func _pause_game() -> void:
	get_tree().paused = true
	pause_menu.show()

func _resume_game() -> void:
	get_tree().paused = false
	pause_menu.hide()

func _on_resume_pressed() -> void:
	_resume_game()

func _on_restart_pressed() -> void:
	_resume_game()
	game_manager.reset_level()

func _on_quit_to_menu_pressed() -> void:
	_show_main_menu()

func _on_level_loaded(level_name: String, level_index: int, total_levels: int) -> void:
	hud.set_level_info(level_name, level_index, total_levels)

func _on_move_count_changed(count: int) -> void:
	hud.set_move_count(count)

func _on_split_state_changed(is_split: bool, active_half: int) -> void:
	hud.set_split_state(is_split, active_half)

func _on_level_completed() -> void:
	hud.show_status("Level clear!", 0.8)
	await get_tree().create_timer(0.9).timeout
	if game_manager.has_next_level():
		game_manager.start_level(game_manager.get_current_level_index() + 1)
	else:
		_show_main_menu()

func _on_level_failed(_reason: String) -> void:
	hud.show_status("Fell!", 0.8)
