extends Control
class_name DungeonMinimap

## Draws the generated dungeon as a compact, always-current graph.
const PANEL_COLOR := Color(0.035, 0.055, 0.075, 0.0)
const BORDER_COLOR := Color(0.698, 0.0, 0.0, 0.0)
const LOCKED_EDGE_COLOR := Color(0.36, 0.4, 0.45, 0.8)
const OPEN_EDGE_COLOR := Color(0.7, 0.0, 0.0, 0.95)
const ROOM_COLOR := Color(0.18, 0.24, 0.3, 1.0)
const EXPLORED_ROOM_COLOR := Color(0.384, 0.433, 0.388, 1.0)
const CURRENT_ROOM_COLOR := Color(1.0, 0.452, 0.462, 0.95)
const PRIOR_ROOM_COLOR := Color(0.51, 0.26, 0.253, 0.95)

var map_rooms : Array[Room] = []
var map_doors : Array[Door] = []
var current_room : Room
var prior_room : Room

func set_graph(rooms : Array[Room], doors : Array[Door]) -> void:
	# The START room is a staging area, not a dungeon room, so it is not shown.
	# The remaining shallow copies retain room/door state even after Game removes START.
	map_rooms.clear()
	map_doors.clear()
	for room in rooms:
		if room.letter_id != "START":
			map_rooms.append(room)
	for door in doors:
		if door.room1.letter_id != "START" and door.room2.letter_id != "START":
			map_doors.append(door)
	queue_redraw()

func set_current_room(room : Room, previous_room : Room = null) -> void:
	current_room = room
	prior_room = previous_room
	queue_redraw()

func refresh() -> void:
	queue_redraw()

func _draw() -> void:
	var panel := Rect2(Vector2.ZERO, size)
	draw_style_box(_make_panel_style(), panel)
	if map_rooms.is_empty():
		return

	var positions := _get_room_positions()
	for door in map_doors:
		if positions.has(door.room1) and positions.has(door.room2):
			var edge_color := OPEN_EDGE_COLOR if not door.is_locked else LOCKED_EDGE_COLOR
			draw_line(positions[door.room1], positions[door.room2], edge_color, 2.5, true)

	var font := ThemeDB.fallback_font
	var node_radius := clampf(minf(size.x, size.y) * 0.055, 10.0, 15.0)
	var font_size := int(node_radius * 1.25)
	for room in map_rooms:
		var node_position : Vector2 = positions[room]
		var fill_color := ROOM_COLOR
		if room.orb_found:
			fill_color = EXPLORED_ROOM_COLOR
		if room == prior_room:
			fill_color = PRIOR_ROOM_COLOR
		if room == current_room:
			fill_color = CURRENT_ROOM_COLOR
		draw_circle(node_position, node_radius, fill_color)
		draw_arc(node_position, node_radius, 0.0, TAU, 20, Color.WHITE, 1.25, true)

		var label := "S" if room.letter_id == "START" else room.letter_id
		var text_size := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		var text_baseline := node_position + Vector2(
			-text_size.x * 0.5,
			(font.get_ascent(font_size) - font.get_descent(font_size)) * 0.5
		)
		draw_string(font, text_baseline, label,
				HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)

func _get_room_positions() -> Dictionary:
	var positions := {}
	var center := size * 0.5
	var radius := maxf(20.0, minf(size.x, size.y) * 0.37)
	for index in map_rooms.size():
		var angle := -PI * 0.5 + TAU * float(index) / float(map_rooms.size())
		positions[map_rooms[index]] = center + Vector2(cos(angle), sin(angle)) * radius
	return positions

func _make_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL_COLOR
	style.border_color = BORDER_COLOR
	style.set_border_width_all(2)
	style.set_corner_radius_all(10)
	return style
