# minimap_manager.gd
extends Node2D

class_name MinimapManager

@onready var dungeon: Dungeon = get_node("/root/Dungeon") # Assumed path for easy access
var discovered_nodes: Dictionary = {}  # Key: Room Name, Value: Room Object
var discovered_edges: Array[Door] = []  # List of unique Door objects
var is_minimap_visible: bool = false

signal graph_updated_needed # Signal to self and other systems when state changes

func _ready():
	# Connect to the global signal emitted when discovery state might change.
	# Assuming Game/game.gd emits this signal upon orb pickup or movement.
	# You may need to adjust 'connect' based on the actual signal name in game.gd
	if get_tree().has_signal("graph_updated_needed"): # Placeholder check
		self.connect("graph_updated_needed", Callable(self, "_on_game_state_change"))

func _input(event):
	# Handle key press for toggling minimap visibility (e.g., pressing 'M')
	if event.is_action_pressed("ui_select"): # Placeholder action check
		toggle_minimap_visibility()
		emit_signal("graph_updated_needed")

func toggle_minimap_visibility():
	# Toggle the internal state and then redraw
	is_minimap_visible = !is_minimap_visible
	$MinimapContainer.visible = is_minimap_visible # Assumes a child container exists
	if is_minimap_visible:
		queue_redraw()

func _on_game_state_change():
	# This function acts as the main trigger hook for all state changes
	update_graph_data()
	queue_redraw()


## CORE LOGIC: Filters the full dungeon graph to only show discovered parts. ##
func update_graph_data():
	# 1. Reset internal state first
	discovered_nodes.clear()
	discovered_edges.clear()

	var rooms = get_node("Dungeon/dungeon.gd").rooms_array # Assuming Dungeon node holds the array
	var doors = get_node("Dungeon/dungeon.gd").doors_array # Assuming Dungeon node holds the array

	# 2. Filter Nodes (Rooms)
	for room in rooms:
		if room and room.orb_found:
			discovered_nodes[room.letter_id] = room

	print("MinimapManager: Found %d discovered nodes." % discovered_nodes.size())

	# 3. Filter Edges (Doors)
	var unique_edges := {} # Use a dictionary to prevent duplicate edges due to bidirectional definition
	for door in doors:
		if door and door.room1 in discovered_nodes and door.room2 in discovered_nodes:
			# Create a unique key for the pair regardless of order (e.g., "A->B")
			var room1_id = door.room1.letter_id
			var room2_id = door.room2.letter_id
			var edge_key = min(room1_id, room2_id) + "-" + max(room1_id, room2_id)

			if edge_key not in unique_edges:
				discovered_edges.append(door)
				unique_edges[edge_key] = true # Mark as added

	print("MinimapManager: Found %d visible edges." % discovered_edges.size())


## RENDERING LOGIC: Draws the graph onto the CanvasItem ##
func _draw():
	if not is_minimap_visible:
		return

	# 1. Clear previous drawings (Nodes and Edges)
	queue_redraw()

	# 2. Draw Edges first (so nodes appear 'on top')
	for door in discovered_edges:
		var start_pos = map_room(door.room1)
		var end_pos = map_room(door.room2)

		if start_pos and end_pos:
			draw_line(start_pos, end_pos, Color.WHITE * 0.7, 2.0) # Gray/White line

	# 3. Draw Nodes (Rooms)
	for room in discovered_nodes.values():
		var pos = map_room(room)
		if pos:
			# Draw a circle representing the node
			draw_circle(pos, 5.0, Color.from_hsv(randf(), 0.7, 1.0), 1.0) # Use unique colors

func map_room(room: Room):
	# **PLACEHOLDER - This is the most critical piece needing architectural input.**
	# In a real implementation, this function must translate the abstract room ID (A-Z)
	# into normalized screen coordinates on the minimap canvas.
	# For now, we'll use a simple placeholder calculation based on its letter ID.
	if not room: return null

	var id_char = room.letter_id[0] # Get the first letter char
	var index = int(id_char) - int("A") # Simple 0-indexed mapping (Requires A-Z rooms)

	# Example placeholder math: assumes a grid layout of discovered rooms
	var x = sin(index * 0.5) * 200 + 100
	var y = cos(index * 0.3) * 150 + 100
	return Vector2(x, y)

# Need to connect this script to the main Game scene's structure.
