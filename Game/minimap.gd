extends Control
class_name DungeonMinimap

## Draws the active dungeon as a graph: rooms are nodes and doors are edges.

@export var padding: float = 22.0
@export var node_radius: float = 10.0

var rooms: Array[Room] = []
var doors: Array[Door] = []
var current_room: Room
var panel_style: StyleBoxFlat

func _ready() -> void:
	panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.039, 0.051, 0.078, 0.0)
	#panel_style.border_color = Color(0.75, 0.68, 0.45, 0.8)
	#panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(8)

func set_dungeon_graph(new_rooms: Array[Room], new_doors: Array[Door], active_room: Room) -> void:
	rooms = new_rooms
	doors = new_doors
	current_room = active_room
	queue_redraw()

func _draw() -> void:
	if rooms.is_empty() or panel_style == null:
		return

	draw_style_box(panel_style, Rect2(Vector2.ZERO, size))
	#draw_string(get_theme_default_font(), Vector2(12.0, 22.0), "DUNGEON MAP", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 14, Color(0.88, 0.84, 0.7))

	var positions := _get_room_positions()
	_draw_doors(positions)
	_draw_rooms(positions)

func _get_room_positions() -> Dictionary:
	var positions := {}
	var center := Vector2(size.x * 0.5, size.y * 0.56)
	var available_radius := minf((size.x - padding * 2.0) * 0.5, (size.y - 48.0 - padding) * 0.5)
	var radius := maxf(20.0, available_radius - node_radius)

	if rooms.size() == 1:
		positions[rooms[0]] = center
		return positions

	for index in rooms.size():
		var angle := TAU * float(index) / float(rooms.size()) - PI * 0.5
		positions[rooms[index]] = center + Vector2(cos(angle), sin(angle)) * radius
	return positions

func _draw_doors(positions: Dictionary) -> void:
	for door in doors:
		if not positions.has(door.room1) or not positions.has(door.room2):
			continue

		var color := Color(0.33, 0.37, 0.45, 0.9) if door.is_locked else Color(0.7, 0, 0, 0.95)
		var width := 2.0 if door.is_locked else 3.0
		draw_line(positions[door.room1], positions[door.room2], color, width, true)

func _draw_rooms(positions: Dictionary) -> void:
	var font := get_theme_default_font()
	for room in rooms:
		var position: Vector2 = positions[room]
		var fill_color := room.mod_color.darkened(0.25)
		var outline_color := Color(0.931, 0.0, 0.113, 0.569) if room.orb_found else Color(0.42, 0.42, 0.46, 0.8)
		var outline_width := 2.0

		if room == current_room:
			fill_color = Color(1.0, 0.29, 0.24, 1.0)
			outline_color = Color.WHITE
			outline_width = 3.0

		draw_circle(position, node_radius, fill_color)
		draw_arc(position, node_radius, 0.0, TAU, 20, outline_color, outline_width, true)
		draw_string(font, position + Vector2(-node_radius, 4.5), room.letter_id, HORIZONTAL_ALIGNMENT_CENTER, node_radius * 2.0, 12, Color.BLACK)
