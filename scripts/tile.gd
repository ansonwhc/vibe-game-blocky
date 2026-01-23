extends Node3D
class_name Tile

const TEXTURE_DARK_PATH = "res://assets/texture/prototype_dark.png"
const TEXTURE_GREEN_PATH = "res://assets/texture/prototype_green.png"
const TEXTURE_ORANGE_PATH = "res://assets/texture/prototype_orange.png"
const TEXTURE_RED_PATH = "res://assets/texture/prototype_red.png"
const TEXTURE_BLUE_PATH = "res://assets/texture/prototype_blue.png"
const TEXTURE_LIGHT_PATH = "res://assets/texture/prototype_light.png"
const TILE_TRIPLANAR_SCALE = Vector3(0.1, 0.1, 0.1)

# const COLOR_FLOOR = Color(0.78, 0.78, 0.78)
const COLOR_FLOOR = Color(1,1,1)
# const COLOR_GOAL = Color(0.35, 0.92, 0.35)
const COLOR_GOAL = Color(1,1,1)
# const COLOR_WEAK = Color(1.0, 0.65, 0.3)
const COLOR_WEAK = Color(1,0,0)
# const COLOR_TRIGGER = Color(1.0, 0.32, 0.32)
const COLOR_TRIGGER = Color(1,0,0)
# const COLOR_TELEPORTER = Color(0.35, 0.65, 1.0)
const COLOR_TELEPORTER = Color(1,1,1)
# const COLOR_BRIDGE_ACTIVE = Color(0.35, 0.82, 0.95)
const COLOR_BRIDGE_ACTIVE = Color(1,1,1)
# const COLOR_BRIDGE_INACTIVE = Color(0.3, 0.3, 0.3)
const COLOR_BRIDGE_INACTIVE = Color(1,1,1)

static var material_cache: Dictionary = {}
static var cached_triplanar_scale := Vector3.ZERO

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
	_ensure_materials()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(tile_size, tile_thickness, tile_size)
	mesh_instance.mesh = mesh
	mesh_instance.material_override = _material_for_type(tile_type, is_active)
	if tile_type == "bridge":
		visible = is_active
	else:
		visible = true

static func _ensure_materials() -> void:
	if material_cache.is_empty() or cached_triplanar_scale != TILE_TRIPLANAR_SCALE:
		material_cache.clear()
		cached_triplanar_scale = TILE_TRIPLANAR_SCALE
		material_cache["floor"] = _make_material(TEXTURE_DARK_PATH, COLOR_FLOOR)
		material_cache["goal"] = _make_material(TEXTURE_GREEN_PATH, COLOR_GOAL)
		material_cache["weak"] = _make_material(TEXTURE_ORANGE_PATH, COLOR_WEAK)
		material_cache["switch"] = _make_material(TEXTURE_RED_PATH, COLOR_TRIGGER)
		material_cache["button"] = _make_material(TEXTURE_RED_PATH, COLOR_TRIGGER)
		material_cache["teleporter"] = _make_material(TEXTURE_BLUE_PATH, COLOR_TELEPORTER)
		material_cache["bridge_active"] = _make_material(TEXTURE_LIGHT_PATH, COLOR_BRIDGE_ACTIVE)
		material_cache["bridge_inactive"] = _make_material(TEXTURE_DARK_PATH, COLOR_BRIDGE_INACTIVE)
		return
	for material in material_cache.values():
		if material is StandardMaterial3D:
			_apply_uv_settings(material)

static func _make_material(texture_path: String, tint: Color = Color(1.0, 1.0, 1.0)) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	var texture = _load_texture(texture_path)
	if texture != null:
		material.albedo_texture = texture
		_apply_uv_settings(material)
	material.albedo_color = tint
	return material

static func _load_texture(texture_path: String) -> Texture2D:
	var image := Image.new()
	if image.load(texture_path) != OK:
		push_warning("Tile texture missing: %s" % texture_path)
		return null
	return ImageTexture.create_from_image(image)

static func _apply_uv_settings(material: StandardMaterial3D) -> void:
	material.uv1_triplanar = true
	material.uv1_scale = TILE_TRIPLANAR_SCALE
	material.uv1_world_triplanar = true

func _material_for_type(tile_name: String, is_active: bool) -> StandardMaterial3D:
	if tile_name == "bridge":
		return material_cache["bridge_active"] if is_active else material_cache["bridge_inactive"]
	return material_cache.get(tile_name, material_cache["floor"])
