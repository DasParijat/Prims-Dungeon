extends Node
class_name PrimMST

func calculate_mst(rooms_array : Array[Room], doors_array : Array[Door]) -> int:
	## Calculates the total weight of the MST using Prim's Algorithm
	var total_weight = 0
	var visited_rooms = {}
	var priority_queue = []
	
	# Start with the first room
	visited_rooms[rooms_array[0]] = true
	
	# Add all doors connected to the first room to the priority queue
	for door in doors_array:
		if door.room1 == rooms_array[0] or door.room2 == rooms_array[0]:
			priority_queue.append(door)
	
	while priority_queue.size() > 0:
		# Sort the priority queue initially
		priority_queue.sort_custom(Callable(self, "_compare_door_cost"))
		
		# Get the door with the smallest cost
		var current_door = priority_queue.pop_front()
		
		# Check if the door connects to an unvisited room
		var next_room = null
		if not visited_rooms.has(current_door.room1):
			next_room = current_door.room1
		elif not visited_rooms.has(current_door.room2):
			next_room = current_door.room2
		
		if next_room != null:
			# Add the cost of the door to the total weight
			total_weight += current_door.cost
			
			# Mark the room as visited
			visited_rooms[next_room] = true
			
			# Add all doors connected to the new room to the priority queue
			for door in doors_array:
				if door.room1 == next_room or door.room2 == next_room:
					priority_queue.append(door)
				
	return total_weight


func _compare_door_cost(a : Door, b : Door) -> bool:
	## Helper function to compare door costs
	return a.cost < b.cost
