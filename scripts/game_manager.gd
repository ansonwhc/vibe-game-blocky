extends Node3D
class_name GameManager

signal level_loaded(level_name: String, level_index: int, total_levels: int)
signal split_state_changed(is_split: bool, active_half: int)
signal move_count_changed(count: int)
signal level_completed
signal level_failed(reason: String)

@export var tile_size := 2.0
@export var tile_thickness := 0.3
@export var cube_size := 1.6
@export var move_duration := 0.18

@onready var tiles_root: Node3D = $Tiles
@onready var block_visual: BlockVisual = $Block
@onready var camera: Camera3D = $Camera3D

var levels: Array = []
var current_level_index := -1
var current_level: Dictionary = {}
var tile_infos: Dictionary = {}
var tile_nodes: Dictionary = {}
var bridge_states: Dictionary = {}
var grid_size := Vector2i.ZERO
var grid_origin := Vector3.ZERO

var cell_a := Vector2i.ZERO
var cell_b := Vector2i.ZERO
var is_split := false
var active_half := 0
var is_moving := false
var is_falling := false
var move_count := 0

var tile_scene := preload("res://scenes/tile.tscn")

func _ready() -> void:
	levels = LevelData.get_levels()

func start_level(level_index: int) -> void:
	if level_index < 0 or level_index >= levels.size():
		return
	current_level_index = level_index
	_load_level(levels[level_index])

func has_next_level() -> bool:
	return current_level_index + 1 < levels.size()

func get_current_level_index() -> int:
	return current_level_index

func process_input() -> void:
	if is_moving or is_falling:
		return
	if Input.is_action_just_pressed("reset_level"):
		reset_level()
		return
	if is_split and Input.is_action_just_pressed("switch_half"):
		active_half = 1 - active_half
		block_visual.set_active_half(active_half, is_split)
		emit_signal("split_state_changed", is_split, active_half)
		return
	var dir = _read_direction()
	if dir != Vector2i.ZERO:
		_attempt_move(dir)

func reset_level() -> void:
	if current_level_index == -1:
		return
	_load_level(levels[current_level_index])

func _read_direction() -> Vector2i:
	if Input.is_action_just_pressed("move_up"):
		return Vector2i(0, -1)
	if Input.is_action_just_pressed("move_down"):
		return Vector2i(0, 1)
	if Input.is_action_just_pressed("move_left"):
		return Vector2i(-1, 0)
	if Input.is_action_just_pressed("move_right"):
		return Vector2i(1, 0)
	return Vector2i.ZERO

func _attempt_move(dir: Vector2i) -> void:
	if is_moving or is_falling:
		return
	var previous_cells = _occupied_cells()
	var next_a = cell_a
	var next_b = cell_b
	if is_split:
		var split_move = _compute_split_move(dir)
		if split_move.is_empty():
			return
		next_a = split_move["a"]
		next_b = split_move["b"]
	else:
		var roll = _compute_roll(cell_a, cell_b, dir)
		next_a = roll["a"]
		next_b = roll["b"]
	move_count += 1
	emit_signal("move_count_changed", move_count)
	is_moving = true
	await block_visual.animate_to(cell_a, cell_b, next_a, next_b, is_split, active_half, move_duration)
	cell_a = next_a
	cell_b = next_b
	await _post_move(previous_cells)
	is_moving = false

func _post_move(previous_cells: Array) -> void:
	var current_cells = _occupied_cells()
	if _is_any_cell_invalid(current_cells):
		await _trigger_fall("fall")
		return
	var entered_cells = _entered_cells(previous_cells, current_cells)
	_handle_triggers(entered_cells)
	if _is_any_cell_invalid(current_cells):
		await _trigger_fall("bridge")
		return
	if not is_split:
		if _check_teleporter(current_cells):
			current_cells = _occupied_cells()
	if is_split:
		_check_merge()
		current_cells = _occupied_cells()
	if _check_weak(current_cells):
		await _trigger_fall("weak")
		return
	if _check_goal(current_cells):
		emit_signal("level_completed")

func _load_level(level_data: Dictionary) -> void:
	current_level = level_data
	grid_size = current_level.get("size", Vector2i(7, 7))
	grid_origin = Vector3(-((grid_size.x - 1) * tile_size) * 0.5, 0.0, -((grid_size.y - 1) * tile_size) * 0.5)
	bridge_states = current_level.get("bridge_states", {}).duplicate()
	_clear_tiles()
	tile_infos = current_level.get("tiles", {})
	for cell in tile_infos.keys():
		var info = tile_infos[cell]
		var tile = tile_scene.instantiate()
		tiles_root.add_child(tile)
		var active = _is_tile_active(info)
		tile.setup(info, tile_size, tile_thickness, active)
		tile.position = _cell_to_world(cell)
		tile_nodes[cell] = tile
	block_visual.configure(tile_size, tile_thickness, cube_size, grid_origin)
	cell_a = current_level.get("start", Vector2i.ZERO)
	cell_b = cell_a
	is_split = false
	active_half = 0
	is_moving = false
	is_falling = false
	move_count = 0
	block_visual.set_cells(cell_a, cell_b, is_split, active_half)
	_refresh_bridges()
	_update_camera()
	emit_signal("level_loaded", current_level.get("name", "Level"), current_level_index + 1, levels.size())
	emit_signal("split_state_changed", is_split, active_half)
	emit_signal("move_count_changed", move_count)

func _clear_tiles() -> void:
	for child in tiles_root.get_children():
		child.queue_free()
	tile_nodes.clear()

func _update_camera() -> void:
	var max_dim = max(grid_size.x, grid_size.y)
	camera.position = Vector3(0.0, max_dim * 2.4, max_dim * 2.4)
	camera.look_at(Vector3.ZERO, Vector3.UP)

func _cell_to_world(cell: Vector2i) -> Vector3:
	return Vector3(cell.x * tile_size, 0.0, cell.y * tile_size) + grid_origin

func _is_tile_active(info: Dictionary) -> bool:
	if info.get("type", "") == "bridge":
		return bridge_states.get(info.get("group", ""), false)
	return true

func _refresh_bridges() -> void:
	for cell in tile_nodes.keys():
		var info = tile_infos.get(cell, {})
		if info.get("type", "") == "bridge":
			var active = bridge_states.get(info.get("group", ""), false)
			tile_nodes[cell].set_active(active)

func _occupied_cells() -> Array:
	var cells: Array = []
	cells.append(cell_a)
	if cell_b != cell_a:
		cells.append(cell_b)
	return cells

func _entered_cells(previous_cells: Array, current_cells: Array) -> Array:
	var previous_set: Dictionary = {}
	for cell in previous_cells:
		previous_set[cell] = true
	var entered: Array = []
	for cell in current_cells:
		if not previous_set.has(cell):
			entered.append(cell)
	return entered

func _handle_triggers(entered_cells: Array) -> void:
	for cell in entered_cells:
		var info = tile_infos.get(cell, {})
		match info.get("type", ""):
			"switch", "button":
				var group = info.get("group", "")
				if group != "":
					bridge_states[group] = not bridge_states.get(group, false)
					_refresh_bridges()

func _check_teleporter(cells: Array) -> bool:
	for cell in cells:
		var info = tile_infos.get(cell, {})
		if info.get("type", "") == "teleporter":
			var target_a = info.get("target_a", cell)
			var target_b = info.get("target_b", cell)
			is_split = true
			active_half = 0
			cell_a = target_a
			cell_b = target_b
			block_visual.set_cells(cell_a, cell_b, is_split, active_half)
			emit_signal("split_state_changed", is_split, active_half)
			return true
	return false

func _check_merge() -> void:
	if not is_split:
		return
	if _cells_adjacent(cell_a, cell_b):
		is_split = false
		active_half = 0
		block_visual.set_cells(cell_a, cell_b, is_split, active_half)
		emit_signal("split_state_changed", is_split, active_half)

func _cells_adjacent(first: Vector2i, second: Vector2i) -> bool:
	return abs(first.x - second.x) + abs(first.y - second.y) == 1

func _check_weak(cells: Array) -> bool:
	if is_split:
		return _cell_is_type(cell_a, "weak") or _cell_is_type(cell_b, "weak")
	if cell_a == cell_b and _cell_is_type(cell_a, "weak"):
		return true
	return false

func _check_goal(cells: Array) -> bool:
	return not is_split and cell_a == cell_b and _cell_is_type(cell_a, "goal")

func _cell_is_type(cell: Vector2i, tile_type: String) -> bool:
	var info = tile_infos.get(cell, {})
	return info.get("type", "") == tile_type

func _is_any_cell_invalid(cells: Array) -> bool:
	for cell in cells:
		if not _is_cell_walkable(cell):
			return true
	return false

func _is_cell_walkable(cell: Vector2i) -> bool:
	if not tile_infos.has(cell):
		return false
	var info = tile_infos.get(cell, {})
	if info.get("type", "") == "bridge":
		return bridge_states.get(info.get("group", ""), false)
	return true

func _compute_roll(a: Vector2i, b: Vector2i, dir: Vector2i) -> Dictionary:
	if a == b:
		return {"a": a + dir, "b": a + dir * 2}
	if a.x == b.x:
		var min_y = min(a.y, b.y)
		var max_y = max(a.y, b.y)
		if dir.y == -1:
			return {"a": Vector2i(a.x, min_y - 1), "b": Vector2i(a.x, min_y - 1)}
		if dir.y == 1:
			return {"a": Vector2i(a.x, max_y + 1), "b": Vector2i(a.x, max_y + 1)}
		return {"a": a + dir, "b": b + dir}
	if a.y == b.y:
		var min_x = min(a.x, b.x)
		var max_x = max(a.x, b.x)
		if dir.x == -1:
			return {"a": Vector2i(min_x - 1, a.y), "b": Vector2i(min_x - 1, a.y)}
		if dir.x == 1:
			return {"a": Vector2i(max_x + 1, a.y), "b": Vector2i(max_x + 1, a.y)}
		return {"a": a + dir, "b": b + dir}
	return {"a": a, "b": b}

func _compute_split_move(dir: Vector2i) -> Dictionary:
	var next_a = cell_a
	var next_b = cell_b
	if active_half == 0:
		var candidate = cell_a + dir
		if candidate == cell_b:
			return {}
		next_a = candidate
	else:
		var candidate = cell_b + dir
		if candidate == cell_a:
			return {}
		next_b = candidate
	return {"a": next_a, "b": next_b}

func _trigger_fall(reason: String) -> void:
	if is_falling:
		return
	is_falling = true
	emit_signal("level_failed", reason)
	await block_visual.animate_fall(4.0, 0.35)
	await get_tree().create_timer(0.2).timeout
	reset_level()
