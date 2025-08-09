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
	generate_rooms(num_of_rooms)
	generate_doors()
	
	rooms_array[0].orb_found = true
	points_needed_to_win = PrimMST.new().calculate_mst(rooms_array, doors_array)
	
func generate_rooms(num_of_rooms : int = 10) -> void:
	## Generate rooms, each with a random modulate value
	if num_of_rooms < 5 or num_of_rooms > 26:
		num_of_rooms = 10
	
	for i in range(num_of_rooms):
		rooms_array.append(
			Room.new(alphabet[i], 
					Color(randf_range(0.5,0.8)
						,randf_range(0.5,0.8)
						,randf_range(0.5,0.8)))
			)
		#print("added room: ", rooms_array[i + 1].letter_id)

func generate_doors() -> void:
	## Generate doors for all rooms to connect the dungeon/graph
	add_starting_door()
	add_random_doors()
	connect_doors_alphabetical()

func add_starting_door() -> void:
	## Adds door that connects starting room to Room A
	doors_array = [Door.new(rooms_array[0], rooms_array[1])] # starting door
	doors_array[0].cost = 0 # make sure start door is free
	
func add_random_doors() -> void:
	## Adds random doors to all rooms
	for i in range(rooms_array.size() - 1):
		# Outer loop iterates through each room to give at least one door
		var room1 : int
		var room2 : int
		var new_door : Door
		
		for j in range(rooms_array.size()):
			# Inner loop iterates through possible doors until it comes
			# across one that doesn't exist in room i
			room1 = i + 1
			room2 = randi_range(1, rooms_array.size() - 1)
			while room2 == room1:
				# Make sure r1 & r2 don't match for the new door
				room2 = randi_range(1, rooms_array.size() - 1)
				
			if not has_reverse_door(rooms_array[room1], rooms_array[room2]):
				# This is what checks if a new door is valid
				new_door = Door.new(rooms_array[room1], rooms_array[room2])
				break
		
		if new_door:
			# If a valid new door was found, it adds it to the room
			doors_array.append(new_door)
			# new_door.print_door()
	
func connect_doors_alphabetical() -> void:
	## Adds any extra doors needed to connect all rooms in dungeon
	## by connecting the rooms in alphabetical order.
	# NOTE - Removing this function can cause a small chance of creating an unconnected graph,
	#		however, it may be more interesting to not have them alphabetically connected
	for i in range(rooms_array.size() - 2):
		var new_door : Door = Door.new(rooms_array[i + 1], 
										rooms_array[i + 2])
		if (new_door not in doors_array) and (not has_reverse_door(rooms_array[i + 1], rooms_array[i + 2])):
			doors_array.append(new_door)
			#new_door.print_door()

func has_reverse_door(room1 : Room, room2 : Room) -> bool:
	## Checks if given room1/room2 already has a door representing it's connection
	for door in doors_array:
		if (door.room1 == room2 and door.room2 == room1) or (door.room1 == room1 and door.room2 == room2):
			return true
	return false
