extends Node

signal door_entered(door : Door)
signal game_won()
signal game_reset()
signal game_leave()

var num_of_rooms : int = 10
var points : int = 0 
var orbs_found : int = 0

var in_room_transition : bool = false
