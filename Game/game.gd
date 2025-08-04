extends Node

@onready var color_modulate : CanvasModulate = $Room/Background/ColorModulate
@onready var door_container : HBoxContainer = $Room/MarginContainer/DoorContainer
@onready var background: TextureRect = $Room/Background
@onready var points_label : Label = $UIContainer/PointsLabel
@onready var orb : TextureButton = $Room/Orb

@export_category("Number of Rooms")
@export var MIN_ROOMS : int
@export var MAX_ROOMS : int 

var cur_dungeon : Dungeon

var cur_room : Room
var points : int

var rooms_array : Array[Room]
var doors_array : Array[Door]

var room_transition : bool = false

func _ready() -> void:
	GRH.connect("door_entered", Callable(self, "_on_door_entered"))
	GRH.connect("game_reset", Callable(self, "_on_game_reset"))
	GRH.connect("game_won", Callable(self, "_on_game_won"))
	GRH.connect("game_leave", Callable(self, "_on_game_leave"))
	
	create_dungeon()

	background.texture = preload("uid://dkbm417ua0v0u")
	start_game(rooms_array[0])

func create_dungeon() -> void:
	randomize()
	cur_dungeon = Dungeon.new(GRH.num_of_rooms)
	rooms_array = cur_dungeon.rooms_array
	doors_array = cur_dungeon.doors_array

func start_game(start_room : Room) -> void:
	for door in doors_array:
		# Lock all doors
		door.is_locked = true
	for room in rooms_array:
		# Give orbs to all rooms
		if room.letter_id != "START":
			room.orb_found = false
	
	# Set global values
	GRH.orbs_found = 0
	GRH.points = cur_dungeon.points_needed_to_win 
	if GRH.points <= 0:
		printerr("Game / PrimMST: GIVEN <= 0 POINTS FROM MST CLASS. FREE POINTS AWARDED")
		GRH.points = randi_range(3, 5) * doors_array.size()
	
	# Set up current room
	cur_room = start_room
	if cur_room.letter_id != "START": background.texture = preload("uid://bxr5f1evya50u")
	load_room(cur_room)

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("reset"):
		GRH.emit_signal("game_reset")

func _on_game_reset() -> void:
	if cur_room.letter_id != "START":
		start_game(rooms_array[0])
	else:
		printerr("Game: IN START ROOM, CAN'T RESET")
	
func load_room(room : Room) -> void:
	update_label_text()
	color_modulate.color = room.mod_color
	
	# Clear existing doors
	for child in door_container.get_children():
		child.queue_free()

	# Find all doors connected to current room
	#print(room.letter_id)
	for door in doors_array:
		if door.check_rooms(room):
			var door_scene = preload("uid://bf8rl0c8yy31o").instantiate()
			door_scene.door = door
			door_scene.cur_room = cur_room
			door_container.add_child(door_scene)
	
	if room.orb_found:
		orb.hide()
	else:
		orb.show()
	
func _on_door_entered(door : Door) -> void:
	print(door.room1.letter_id, " ", door.room2.letter_id)
	var next_room : Room
	if door.room1 == cur_room:
		next_room = door.room2
	else:
		next_room = door.room1
	
	if cur_room.letter_id == "START":
		print("removing START")
		rooms_array.pop_front()
		doors_array.pop_front()
	
	cur_room = next_room
	background.texture = preload("uid://bxr5f1evya50u")
	load_room(next_room)

func update_label_text() -> void:
	points_label.text = (str(GRH.points) + " points \n" 
						+ (str(GRH.orbs_found) + " / " + str(rooms_array.size())) 
						+ " orbs \nRoom " + cur_room.letter_id)

func _on_game_won() -> void:
	cur_room = Room.new("WIN", Color(0.8, 0.8, 0.8))
	background.texture = preload("uid://57t1euthr6ct")
	load_room(cur_room)

func _on_orb_pressed() -> void:
	cur_room.orb_found = true
	GRH.orbs_found += 1
	update_label_text()
	if GRH.orbs_found == rooms_array.size():
		GRH.emit_signal("game_won")
		
	orb.hide()

func _on_game_leave() -> void:
	GScene.change_scene(GScene.HOME_MENU)
