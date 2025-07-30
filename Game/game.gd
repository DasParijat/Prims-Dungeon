extends Node2D

@onready var color_modulate : CanvasModulate = $Room/Background/ColorModulate
@onready var door_container : HBoxContainer = $Room/DoorContainer
@onready var background: TextureRect = $Room/Background
@onready var points_label : Label = $PointsLabel
@onready var orb : TextureButton = $Room/Orb

var cur_room : Room
var points : int

var rooms_array : Array[Room] = [Room.new("START", Color(0.5,0.5,0.5))] # starting room
var doors_array : Array[Door]

var room_transition : bool = false

var alphabet : Array[String] = [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
]

func _ready() -> void:
	GRH.connect("door_entered", Callable(self, "_on_door_entered"))
	randomize()
	
	generate_rooms(randi_range(5, 15))
	generate_doors()
	
	rooms_array[0].orb_found = true
	background.texture = preload("uid://dkbm417ua0v0u")
	start_game(rooms_array[0])
	
func generate_rooms(num_of_rooms : int = 10) -> void:
	if num_of_rooms < 5 or num_of_rooms > 26:
		num_of_rooms = 10
		printerr("Game: GIVEN NUM_OF_ROOMS NOT VALID, SET TO 10")
	
	for i in range(num_of_rooms):
		rooms_array.append(
			Room.new(alphabet[i], 
					Color(randf_range(0.5,0.8)
						,randf_range(0.5,0.8)
						,randf_range(0.5,0.8)))
			)
		#print("added room: ", rooms_array[i + 1].letter_id)

# TODO add code to generate dungeon, get starting points
func generate_doors() -> void:
	# Starting door
	# NOTE - no other room should connect to starting door besides A
	doors_array = [Door.new(rooms_array[0], rooms_array[1])] # starting door
	doors_array[0].cost = 0 # make sure start door is free
	#Door.new(rooms_array[0], rooms_array[1]).print_door()

	#print("1ST LOOP")
	## 2nd for loop (add random doors for each room)
	for loop in range(1): #range(clampi(round(rooms_array.size() / 5), 1, 2)):
		for i in range(rooms_array.size() - 1):
			var room1 : int
			var room2 : int
			var new_door : Door
			
			for j in range(rooms_array.size()):
				room1 = i + 1
				room2 = randi_range(1, rooms_array.size() - 1)
				while room2 == room1: #or abs(room2 - room1) == 1:
					room2 = randi_range(1, rooms_array.size() - 1)
					
				if not has_reverse_door(rooms_array[room1], rooms_array[room2]):
					new_door = Door.new(rooms_array[room1], rooms_array[room2])
					break
			
			if new_door:
				doors_array.append(new_door)
				new_door.print_door()
	
	#print("2ND LOOP") 
	# NOTE - Stopping this for loop can cause a small chance of creating an unconnected graph,
	#		however, it may be more interesting to not have them alphabetically connected
	for i in range(rooms_array.size() - 2):
		#break
		var new_door : Door = Door.new(rooms_array[i + 1], 
										rooms_array[i + 2])
		if (new_door not in doors_array) and (not has_reverse_door(rooms_array[i + 1], rooms_array[i + 2])):
			doors_array.append(new_door)
			new_door.print_door()

func has_reverse_door(room1: Room, room2: Room) -> bool:
	for door in doors_array:
		if (door.room1 == room2 and door.room2 == room1) or (door.room1 == room1 and door.room2 == room2):
			return true
	return false

func start_game(start_room : Room) -> void:
	for door in doors_array:
		door.is_locked = true
	for room in rooms_array:
		if room.letter_id != "START":
			room.orb_found = false
	
	GRH.orbs_found = 0
	GRH.points = PrimMST.new().calculate_mst(rooms_array, doors_array)
	if GRH.points <= 0:
		printerr("Game / PrimMST: GIVEN <= 0 POINTS FROM MST CLASS. FREE POINTS AWARDED")
		GRH.points = randi_range(3, 5) * doors_array.size()
	
	cur_room = start_room
	load_room(cur_room)
	
func _process(delta : float) -> void:
	# process solely for handling input
	if Input.is_action_just_pressed("reset") and cur_room.letter_id != "START":
		start_game(rooms_array[0])
	
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
						
func _on_orb_pressed() -> void:
	cur_room.orb_found = true
	GRH.orbs_found += 1
	update_label_text()
	if GRH.orbs_found == rooms_array.size():
		cur_room = Room.new("WIN", Color(0.8, 0.8, 0.8))
		background.texture = preload("uid://57t1euthr6ct")
		load_room(cur_room)
		
	orb.hide()
	
