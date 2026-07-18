extends Node
class_name Room # AKA vertex/node

# {letter = A, orb_found : bool = false, mod_color = Color()}
var letter_id : String = "START" # START is starting room in game, like the menu
var mod_color : Color 
var orb_found : bool = false

func _init(_id : String, _mod_color : Color) -> void:
	letter_id = _id
	mod_color = _mod_color
	orb_found = false
	
func set_orb_found(value: bool):
	if orb_found != value:
		orb_found = value
		# Emit signal indicating that the node's state has changed.
		emit_signal("discovered", letter_id)
