extends Node3D
class_name BlockVisual

const BLOCK_TEXTURE_PATH = "res://addons/prototype_mini_bundle/prototype_light.png"

@onready var combined: MeshInstance3D = $Combined
@onready var cube_a: MeshInstance3D = $CubeA
@onready var cube_b: MeshInstance3D = $CubeB

var tile_size := 2.0
var tile_thickness := 0.3
var cube_size := 1.6
var grid_origin := Vector3.ZERO

var base_color := Color(0.9, 0.9, 0.9)
var active_color := Color(1.0, 0.85, 0.4)
var base_material: StandardMaterial3D
var active_material: StandardMaterial3D

func configure(new_tile_size: float, new_tile_thickness: float, new_cube_size: float, new_grid_origin: Vector3) -> void:
	tile_size = new_tile_size
	tile_thickness = new_tile_thickness
	cube_size = new_cube_size
	grid_origin = new_grid_origin
	_apply_meshes()

func set_cells(cell_a: Vector2i, cell_b: Vector2i, is_split: bool, active_half: int) -> void:
	if is_split:
		_show_split()
		_apply_split_positions(cell_a, cell_b)
	else:
		_show_combined()
		_apply_combined_transform(cell_a, cell_b)
	set_active_half(active_half, is_split)

func animate_to(prev_a: Vector2i, prev_b: Vector2i, next_a: Vector2i, next_b: Vector2i, is_split: bool, active_half: int, duration: float) -> void:
	if is_split:
		_show_split()
		var positions = _split_cube_positions(next_a, next_b)
		var tween := create_tween()
		tween.tween_property(cube_a, "global_position", positions[0], duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property(cube_b, "global_position", positions[1], duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
	else:
		_show_combined()
		await _animate_roll(prev_a, prev_b, next_a, next_b, duration)
	set_active_half(active_half, is_split)

func animate_fall(drop_distance: float, duration: float) -> void:
	var tween := create_tween()
	if combined.visible:
		tween.tween_property(combined, "global_position", combined.global_position + Vector3(0.0, -drop_distance, 0.0), duration)
	else:
		tween.tween_property(cube_a, "global_position", cube_a.global_position + Vector3(0.0, -drop_distance, 0.0), duration)
		tween.parallel().tween_property(cube_b, "global_position", cube_b.global_position + Vector3(0.0, -drop_distance, 0.0), duration)
	await tween.finished

func set_active_half(active_half: int, is_split: bool) -> void:
	if not is_split:
		_set_cube_material(combined, base_material)
		return
	_set_cube_material(cube_a, active_material if active_half == 0 else base_material)
	_set_cube_material(cube_b, active_material if active_half == 1 else base_material)

func _apply_meshes() -> void:
	_ensure_materials()
	var cube_mesh := BoxMesh.new()
	cube_mesh.size = Vector3(cube_size, cube_size, cube_size)
	cube_a.mesh = cube_mesh
	cube_b.mesh = cube_mesh
	var combined_mesh := BoxMesh.new()
	combined_mesh.size = Vector3(cube_size * 2.0, cube_size, cube_size)
	combined.mesh = combined_mesh
	_set_cube_material(cube_a, base_material)
	_set_cube_material(cube_b, base_material)
	_set_cube_material(combined, base_material)

func _apply_split_positions(cell_a: Vector2i, cell_b: Vector2i) -> void:
	var positions = _split_cube_positions(cell_a, cell_b)
	cube_a.global_position = positions[0]
	cube_b.global_position = positions[1]

func _apply_combined_transform(cell_a: Vector2i, cell_b: Vector2i) -> void:
	combined.global_transform = _combined_transform(cell_a, cell_b)

func _split_cube_positions(cell_a: Vector2i, cell_b: Vector2i) -> Array:
	var base_y = tile_thickness * 0.5 + cube_size * 0.5
	var pos_a = _cell_to_world(cell_a) + Vector3(0.0, base_y, 0.0)
	var pos_b = _cell_to_world(cell_b) + Vector3(0.0, base_y, 0.0)
	return [pos_a, pos_b]

func _combined_transform(cell_a: Vector2i, cell_b: Vector2i) -> Transform3D:
	var center = _combined_center(cell_a, cell_b)
	var basis = _combined_basis(cell_a, cell_b)
	return Transform3D(basis, center)

func _combined_center(cell_a: Vector2i, cell_b: Vector2i) -> Vector3:
	var flat_y = tile_thickness * 0.5 + cube_size * 0.5
	var upright_y = tile_thickness * 0.5 + cube_size
	if cell_a == cell_b:
		var pos = _cell_to_world(cell_a)
		pos.y = upright_y
		return pos
	var pos_a = _cell_to_world(cell_a)
	var pos_b = _cell_to_world(cell_b)
	var center = (pos_a + pos_b) * 0.5
	center.y = flat_y
	return center

func _combined_basis(cell_a: Vector2i, cell_b: Vector2i) -> Basis:
	if cell_a == cell_b:
		return Basis(Vector3(0.0, 0.0, 1.0), PI * 0.5)
	if cell_a.y == cell_b.y:
		return Basis.IDENTITY
	return Basis(Vector3.UP, PI * 0.5)

func _cell_to_world(cell: Vector2i) -> Vector3:
	return Vector3(cell.x * tile_size, 0.0, cell.y * tile_size) + grid_origin

func _ensure_materials() -> void:
	if base_material != null:
		return
	base_material = StandardMaterial3D.new()
	var texture = _load_texture(BLOCK_TEXTURE_PATH)
	if texture != null:
		base_material.albedo_texture = texture
		base_material.uv1_triplanar = true
	base_material.albedo_color = base_color
	active_material = base_material.duplicate() as StandardMaterial3D
	active_material.albedo_color = active_color

func _load_texture(texture_path: String) -> Texture2D:
	var image := Image.new()
	if image.load(texture_path) != OK:
		push_warning("Block texture missing: %s" % texture_path)
		return null
	return ImageTexture.create_from_image(image)

func _set_cube_material(cube: MeshInstance3D, material: StandardMaterial3D) -> void:
	cube.material_override = material

func _show_split() -> void:
	combined.visible = false
	cube_a.visible = true
	cube_b.visible = true

func _show_combined() -> void:
	combined.visible = true
	cube_a.visible = false
	cube_b.visible = false

func _animate_roll(prev_a: Vector2i, prev_b: Vector2i, next_a: Vector2i, next_b: Vector2i, duration: float) -> void:
	var start_transform = combined.global_transform
	var target_transform = _combined_transform(next_a, next_b)
	var move_dir = target_transform.origin - start_transform.origin
	move_dir.y = 0.0
	if move_dir.length() < 0.001:
		combined.global_transform = target_transform
		return
	var pivot = _pivot_for_move(prev_a, prev_b, move_dir)
	var axis = _axis_for_move(move_dir)
	var plus_transform = _rotated_transform(start_transform, pivot, axis, PI * 0.5)
	var minus_transform = _rotated_transform(start_transform, pivot, axis, -PI * 0.5)
	var angle := PI * 0.5
	if minus_transform.origin.distance_to(target_transform.origin) < plus_transform.origin.distance_to(target_transform.origin):
		angle = -PI * 0.5
	var tween := create_tween()
	tween.tween_method(_apply_roll_transform.bind(start_transform, pivot, axis, angle), 0.0, 1.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	combined.global_transform = target_transform

func _apply_roll_transform(t: float, start_transform: Transform3D, pivot: Vector3, axis: Vector3, angle: float) -> void:
	combined.global_transform = _rotated_transform(start_transform, pivot, axis, angle * t)

func _pivot_for_move(cell_a: Vector2i, cell_b: Vector2i, move_dir: Vector3) -> Vector3:
	var min_x = min(cell_a.x, cell_b.x)
	var max_x = max(cell_a.x, cell_b.x)
	var min_y = min(cell_a.y, cell_b.y)
	var max_y = max(cell_a.y, cell_b.y)
	var pivot_x = float(min_x + max_x) * 0.5
	var pivot_y = float(min_y + max_y) * 0.5
	if abs(move_dir.x) > abs(move_dir.z):
		pivot_x = float(max_x + 0.5) if move_dir.x > 0.0 else float(min_x - 0.5)
	else:
		pivot_y = float(max_y + 0.5) if move_dir.z > 0.0 else float(min_y - 0.5)
	return Vector3(pivot_x * tile_size, tile_thickness * 0.5, pivot_y * tile_size) + grid_origin

func _axis_for_move(move_dir: Vector3) -> Vector3:
	if abs(move_dir.x) > abs(move_dir.z):
		return Vector3(0.0, 0.0, 1.0)
	return Vector3(1.0, 0.0, 0.0)

func _rotated_transform(start: Transform3D, pivot: Vector3, axis: Vector3, angle: float) -> Transform3D:
	var rot_basis = Basis(axis, angle)
	var new_basis = rot_basis * start.basis
	var new_origin = pivot + rot_basis * (start.origin - pivot)
	return Transform3D(new_basis, new_origin)
