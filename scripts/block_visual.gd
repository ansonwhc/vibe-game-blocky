extends Node3D
class_name BlockVisual

@onready var cube_a: MeshInstance3D = $CubeA
@onready var cube_b: MeshInstance3D = $CubeB

var tile_size := 2.0
var tile_thickness := 0.3
var cube_size := 1.6
var grid_origin := Vector3.ZERO

var base_color := Color(0.9, 0.9, 0.9)
var active_color := Color(1.0, 0.85, 0.4)

func configure(new_tile_size: float, new_tile_thickness: float, new_cube_size: float, new_grid_origin: Vector3) -> void:
	tile_size = new_tile_size
	tile_thickness = new_tile_thickness
	cube_size = new_cube_size
	grid_origin = new_grid_origin
	_apply_meshes()

func set_cells(cell_a: Vector2i, cell_b: Vector2i, is_split: bool, active_half: int) -> void:
	_apply_positions(cell_a, cell_b, is_split)
	set_active_half(active_half, is_split)

func animate_to(cell_a: Vector2i, cell_b: Vector2i, is_split: bool, active_half: int, duration: float) -> void:
	var positions = _get_cube_positions(cell_a, cell_b, is_split)
	var tween := create_tween()
	tween.tween_property(cube_a, "global_position", positions[0], duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(cube_b, "global_position", positions[1], duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	set_active_half(active_half, is_split)

func animate_fall(drop_distance: float, duration: float) -> void:
	var tween := create_tween()
	tween.tween_property(cube_a, "global_position", cube_a.global_position + Vector3(0.0, -drop_distance, 0.0), duration)
	tween.parallel().tween_property(cube_b, "global_position", cube_b.global_position + Vector3(0.0, -drop_distance, 0.0), duration)
	await tween.finished

func set_active_half(active_half: int, is_split: bool) -> void:
	if not is_split:
		_set_cube_color(cube_a, base_color)
		_set_cube_color(cube_b, base_color)
		return
	_set_cube_color(cube_a, active_color if active_half == 0 else base_color)
	_set_cube_color(cube_b, active_color if active_half == 1 else base_color)

func _apply_meshes() -> void:
	var mesh := BoxMesh.new()
	mesh.size = Vector3(cube_size, cube_size, cube_size)
	cube_a.mesh = mesh
	cube_b.mesh = mesh
	_set_cube_color(cube_a, base_color)
	_set_cube_color(cube_b, base_color)

func _apply_positions(cell_a: Vector2i, cell_b: Vector2i, is_split: bool) -> void:
	var positions = _get_cube_positions(cell_a, cell_b, is_split)
	cube_a.global_position = positions[0]
	cube_b.global_position = positions[1]

func _get_cube_positions(cell_a: Vector2i, cell_b: Vector2i, is_split: bool) -> Array:
	var base_y = tile_thickness * 0.5 + cube_size * 0.5
	var pos_a = _cell_to_world(cell_a) + Vector3(0.0, base_y, 0.0)
	var pos_b = _cell_to_world(cell_b) + Vector3(0.0, base_y, 0.0)
	if not is_split and cell_a == cell_b:
		pos_b.y += cube_size
	return [pos_a, pos_b]

func _cell_to_world(cell: Vector2i) -> Vector3:
	return Vector3(cell.x * tile_size, 0.0, cell.y * tile_size) + grid_origin

func _set_cube_color(cube: MeshInstance3D, color: Color) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	cube.material_override = material
