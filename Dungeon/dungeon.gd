extends Node
class_name Dungeon

var points_needed_to_win : int

var rooms_array : Array[Room] = [Room.new("START", Color(0.5,0.5,0.5))] # starting room
var doors_array : Array[Door]

var alphabet : Array[String] = [
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", 
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
]

func _init(num_of_rooms : int) -> void:
	randomize()
	
	generate_rooms(num_of_rooms)
	generate_doors()
	
	rooms_array[0].orb_found = true
	points_needed_to_win = PrimMST.new().calculate_mst(rooms_array, doors_array)
	
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
