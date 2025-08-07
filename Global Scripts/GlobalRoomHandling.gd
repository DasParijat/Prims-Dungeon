extends Node
# This autoload handles signals and values related to the game itself

# Signals
signal door_entered(door : Door) # Emitted when clicked on door
signal go_prev_room() # Go to previous room
signal game_won()
signal game_reset()
signal game_leave()

# Room related variables
var num_of_rooms : int = 10
var prev_rooms : Array[Room]

# Gameplay related variables
var points : int = 0 
var orbs_found : int = 0
