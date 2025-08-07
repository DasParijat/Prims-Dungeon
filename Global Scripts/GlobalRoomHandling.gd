extends Node

signal door_entered(door : Door)
signal go_prev_room()
signal game_won()
signal game_reset()
signal game_leave()

var num_of_rooms : int = 10
var prev_rooms : Array[Room]

var points : int = 0 
var orbs_found : int = 0

var in_room_transition : bool = false
