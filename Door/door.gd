extends Node
class_name Door # AKA edge

#{Room 1 = Room(), Room 2 = Room(), Weight/Cost : int, is_locked : bool}

var room1 : Room
var room2 : Room

var cost : int = randi_range(1, 9)
var is_locked : bool = true

func _init(_room1 : Room, _room2 : Room) -> void:
	room1 = _room1
	room2 = _room2
	cost = randi_range(1, 9)
	is_locked = true

func print_door() -> void:
	print("{",room1.letter_id, ", ", room2.letter_id,"}")
	
func check_rooms(search : Room) -> bool:
	## Checks if room exist within edge
	if room1 == search or room2 == search:
		return true
	return false

func can_unlock(points : int) -> bool:
	## Handles unlocking door
	## Does NOT handle taking away from player cost, 
	## instead whether unlocking was successful or not to Game
	if points >= cost:
		is_locked = false
		return true
	return false
		
