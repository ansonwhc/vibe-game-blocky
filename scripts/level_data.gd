extends Node
class_name LevelData

static func get_levels() -> Array:
	var levels: Array = []
	levels.append(_make_level_one())
	levels.append(_make_level_two())
	levels.append(_make_level_three())
	levels.append(_make_level_four())
	levels.append(_make_level_five())
	return levels

static func _make_level_one() -> Dictionary:
	var tiles: Dictionary = {}
	_fill_rect(tiles, Vector2i(2, 1), Vector2i(4, 4), "floor")
	_add_tile(tiles, Vector2i(3, 2), "goal")
	_add_tile(tiles, Vector2i(3, 3), "weak")
	return {
		"name": "First Steps",
		"size": Vector2i(7, 7),
		"start": Vector2i(3, 4),
		"tiles": tiles,
		"bridge_states": {}
	}

static func _make_level_two() -> Dictionary:
	var tiles: Dictionary = {}
	_fill_rect(tiles, Vector2i(1, 1), Vector2i(3, 4), "floor")
	_fill_rect(tiles, Vector2i(5, 1), Vector2i(7, 3), "floor")
	_add_tile(tiles, Vector2i(2, 2), "switch", {"group": "bridge_a"})
	_add_tile(tiles, Vector2i(4, 2), "bridge", {"group": "bridge_a"})
	_add_tile(tiles, Vector2i(6, 1), "goal")
	return {
		"name": "Bridge Control",
		"size": Vector2i(9, 7),
		"start": Vector2i(2, 4),
		"tiles": tiles,
		"bridge_states": {"bridge_a": false}
	}

static func _make_level_three() -> Dictionary:
	var tiles: Dictionary = {}
	_fill_rect(tiles, Vector2i(1, 1), Vector2i(3, 3), "floor")
	_fill_rect(tiles, Vector2i(1, 4), Vector2i(3, 4), "floor")
	_fill_rect(tiles, Vector2i(6, 4), Vector2i(7, 4), "floor")
	_add_tile(tiles, Vector2i(2, 1), "teleporter", {
		"target_a": Vector2i(1, 1),
		"target_b": Vector2i(3, 1)
	})
	_add_tile(tiles, Vector2i(2, 4), "button", {"group": "bridge_a"})
	_add_tile(tiles, Vector2i(4, 4), "bridge", {"group": "bridge_a"})
	_add_tile(tiles, Vector2i(5, 4), "bridge", {"group": "bridge_a"})
	_add_tile(tiles, Vector2i(6, 4), "goal")
	return {
		"name": "Split Circuit",
		"size": Vector2i(9, 7),
		"start": Vector2i(2, 3),
		"tiles": tiles,
		"bridge_states": {"bridge_a": false}
	}

static func _make_level_four() -> Dictionary:
	var tiles: Dictionary = {}
	_fill_rect(tiles, Vector2i(1, 2), Vector2i(3, 6), "floor")
	_fill_rect(tiles, Vector2i(5, 1), Vector2i(6, 7), "floor")
	_fill_rect(tiles, Vector2i(8, 2), Vector2i(9, 6), "floor")
	_add_tile(tiles, Vector2i(4, 4), "bridge", {"group": "bridge_a"})
	_add_tile(tiles, Vector2i(7, 4), "bridge", {"group": "bridge_b"})
	_add_tile(tiles, Vector2i(2, 4), "switch", {"group": "bridge_a"})
	_add_tile(tiles, Vector2i(5, 3), "switch", {"group": "bridge_b"})
	_add_tile(tiles, Vector2i(6, 5), "weak")
	_add_tile(tiles, Vector2i(9, 4), "goal")
	return {
		"name": "Switchback Run",
		"size": Vector2i(11, 9),
		"start": Vector2i(2, 5),
		"tiles": tiles,
		"bridge_states": {"bridge_a": false, "bridge_b": false}
	}

static func _make_level_five() -> Dictionary:
	var tiles: Dictionary = {}
	_fill_rect(tiles, Vector2i(1, 3), Vector2i(3, 5), "floor")
	_fill_rect(tiles, Vector2i(4, 4), Vector2i(7, 6), "floor")
	_fill_rect(tiles, Vector2i(9, 2), Vector2i(11, 5), "floor")
	_fill_rect(tiles, Vector2i(9, 7), Vector2i(11, 7), "floor")
	_add_tile(tiles, Vector2i(8, 5), "bridge", {"group": "bridge_a"})
	_add_tile(tiles, Vector2i(10, 6), "bridge", {"group": "bridge_b"})
	_add_tile(tiles, Vector2i(5, 6), "button", {"group": "bridge_a"})
	_add_tile(tiles, Vector2i(10, 4), "switch", {"group": "bridge_b"})
	_add_tile(tiles, Vector2i(6, 4), "weak")
	_add_tile(tiles, Vector2i(10, 7), "goal")
	return {
		"name": "Toggle Loop",
		"size": Vector2i(13, 9),
		"start": Vector2i(2, 4),
		"tiles": tiles,
		"bridge_states": {"bridge_a": false, "bridge_b": false}
	}


static func _fill_rect(tiles: Dictionary, start: Vector2i, end: Vector2i, tile_type: String) -> void:
	for x in range(start.x, end.x + 1):
		for y in range(start.y, end.y + 1):
			_add_tile(tiles, Vector2i(x, y), tile_type)

static func _add_tile(tiles: Dictionary, cell: Vector2i, tile_type: String, extra: Dictionary = {}) -> void:
	var info := {"type": tile_type}
	for key in extra.keys():
		info[key] = extra[key]
	tiles[cell] = info
