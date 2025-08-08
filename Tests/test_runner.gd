# TestDungeon.gd
extends Node

# We need to preload the class we're testing.
const Dungeon = preload("res://Dungeon/dungeon.gd")

var total_tests = 0
var passed_tests = 0

# The _ready function will be our test runner.
func _ready() -> void:
	run_all_tests()
	
	# Final report
	print("\n-------------------------------------------")
	print("Test Report: %d/%d tests passed." % [passed_tests, total_tests])
	print("-------------------------------------------")

	# Quit the test runner scene automatically
	get_tree().quit()

func run_all_tests() -> void:
	print("--- Running Dungeon Generation Tests ---")
	
	test_creation_and_room_count()
	test_invalid_room_count_defaults_correctly()
	test_start_door_properties()
	test_graph_is_always_connected()
	test_no_duplicate_doors_or_self_loops()
	test_mst_calculation()
	
	print("\n--- All tests complete ---")

# A helper function to report pass/fail status
func _assert(condition: bool, test_name: String) -> void:
	total_tests += 1
	if condition:
		passed_tests += 1
		print("[PASS] %s" % test_name)
	else:
		printerr("[FAIL] %s" % test_name)

## --- INDIVIDUAL TEST FUNCTIONS ---

func test_creation_and_room_count() -> void:
	var num_rooms = 15
	var dungeon = Dungeon.new(num_rooms)
	# We expect num_rooms + 1 for the "START" room.
	_assert(is_instance_valid(dungeon), "Dungeon instance should be valid.")
	_assert(dungeon.rooms_array.size() == num_rooms + 1, "Should generate the correct number of rooms (15 + START).")

func test_invalid_room_count_defaults_correctly() -> void:
	## The validity check should catch numbers outside the 5-25 range and default to 10.
	var dungeon_low = Dungeon.new(2)
	_assert(dungeon_low.rooms_array.size() == 10 + 1, "Too few rooms (2) should default to 10.")
	
	var dungeon_high = Dungeon.new(30)
	_assert(dungeon_high.rooms_array.size() == 10 + 1, "Too many rooms (30) should default to 10.")

func test_start_door_properties() -> void:
	var dungeon = Dungeon.new(10)
	var start_door_found = false
	for door in dungeon.doors_array:
		# Check if a door connects START (index 0) to Room A (index 1)
		var r1 = door.room1
		var r2 = door.room2
		var start_room = dungeon.rooms_array[0]
		var room_a = dungeon.rooms_array[1]
		
		if (r1 == start_room and r2 == room_a) or (r1 == room_a and r2 == start_room):
			start_door_found = true
			_assert(door.cost == 0, "The door connecting START to Room A should have a cost of 0.")
			break
			
	_assert(start_door_found, "A door connecting START to Room A must exist.")

func test_graph_is_always_connected() -> void:
	# This is the most important test. We run it a few times to be sure.
	var test_runs = 20
	var all_runs_connected = true
	for i in range(test_runs):
		var num_rooms = randi_range(5, 26)
		var dungeon = Dungeon.new(num_rooms)
		if not _is_graph_connected(dungeon):
			all_runs_connected = false
			break
	
	_assert(all_runs_connected, "Graph must be connected across %d random runs." % test_runs)

func test_no_duplicate_doors_or_self_loops() -> void:
	var dungeon = Dungeon.new(20)
	var has_duplicates = false
	var has_self_loops = false
	
	var existing_doors : Array = []
	for door in dungeon.doors_array:
		if door.room1 == door.room2:
			has_self_loops = true
			break
		
		# To check for duplicates like (A,B) and (B,A), we create a sorted key
		var key = [door.room1.letter_id, door.room2.letter_id]
		key.sort()
		var key_string = key[0] + "-" + key[1]
		
		if existing_doors.has(key_string):
			has_duplicates = true
			break
		else:
			existing_doors.append(key_string)
			
	_assert(not has_self_loops, "Graph should not contain self-loops (e.g., Room A to Room A).")
	_assert(not has_duplicates, "Graph should not contain duplicate doors (e.g., A->B and B->A).")

func test_mst_calculation() -> void:
	var dungeon = Dungeon.new(12)
	# We can't easily predict the exact MST cost, but we can check if it's a plausible value.
	# A valid MST cost must be a non-negative integer.
	_assert(dungeon.points_needed_to_win >= 0, "MST cost (points_needed_to_win) should be >= 0.")
	_assert(typeof(dungeon.points_needed_to_win) == TYPE_INT, "MST cost should be an integer.")

# --- HELPER ALGORITHMS ---

# Checks if all rooms in the dungeon are reachable from the start room using BFS.
func _is_graph_connected(dungeon: Dungeon) -> bool:
	if dungeon.rooms_array.is_empty():
		return true # An empty graph is trivially connected.

	var start_node = dungeon.rooms_array[0]
	var visited = {start_node: true}
	var queue = [start_node]
	
	while not queue.is_empty():
		var current_room = queue.pop_front()
		
		# Find all neighbors of the current room
		for door in dungeon.doors_array:
			var neighbor = null
			if door.room1 == current_room:
				neighbor = door.room2
			elif door.room2 == current_room:
				neighbor = door.room1
			
			if neighbor and not visited.has(neighbor):
				visited[neighbor] = true
				queue.append(neighbor)

	# The graph is connected if the number of visited rooms equals the total number of rooms.
	return visited.size() == dungeon.rooms_array.size()
