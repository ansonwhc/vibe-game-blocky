extends Node3D
class_name Tile

@onready var mesh_instance: MeshInstance3D = $Mesh

var tile_type := "floor"
var group_id := ""
var tile_size := 2.0
var tile_thickness := 0.3

func setup(tile_info: Dictionary, new_tile_size: float, new_tile_thickness: float, is_active: bool) -> void:
	tile_type = tile_info.get("type", "floor")
	group_id = tile_info.get("group", "")
	tile_size = new_tile_size
	tile_thickness = new_tile_thickness
	_apply_mesh(is_active)

func set_active(is_active: bool) -> void:
	_apply_mesh(is_active)

func _apply_mesh(is_active: bool) -> void:
	var mesh := BoxMesh.new()
	mesh.size = Vector3(tile_size, tile_thickness, tile_size)
	mesh_instance.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = _color_for_type(tile_type, is_active)
	mesh_instance.material_override = material
	if tile_type == "bridge":
		visible = is_active
	else:
		visible = true

func _color_for_type(tile_name: String, is_active: bool) -> Color:
	match tile_name:
		"goal":
			return Color(0.2, 0.8, 0.2)
		"weak":
			return Color(0.9, 0.5, 0.2)
		"switch":
			return Color(0.85, 0.2, 0.2)
		"button":
			return Color(0.9, 0.7, 0.2)
		"teleporter":
			return Color(0.2, 0.5, 0.9)
		"bridge":
			return Color(0.25, 0.7, 0.85) if is_active else Color(0.2, 0.2, 0.2)
		_:
			return Color(0.6, 0.6, 0.6)
