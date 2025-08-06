extends Control
class_name DoorScene

@onready var button : Button = $"."
@onready var texture : TextureRect = $TextureRect
@onready var cost : Label = $Cost

@onready var door : Door
@onready var cur_room : Room

@onready var door_closed_img = preload("uid://c2g24fa0tauir")
@onready var explored_door_closed_img = preload("uid://cd2ym241n674i")
@onready var door_opened_img = preload("uid://7gfggwe3vnl2")

func _ready() -> void:
	set_door_graphic()

func set_door_graphic() -> void:
	var connected_room : Room = door.room1 if door.room2 == cur_room else door.room2
	
	if door.is_locked:
		texture.texture = explored_door_closed_img if connected_room.orb_found else door_closed_img
		cost.text = str(door.cost)
		
		if door.cost > GRH.points:
			# Indicate visually player lacks enough points for the door
			cost.modulate = Color(0.7, 0, 0)
			texture.modulate = Color(0.8, 0.8, 0.8)
	else:
		texture.texture = door_opened_img
		cost.text = connected_room.letter_id
		
func _on_pressed() -> void:
	if door.is_locked:
		if door.can_unlock(GRH.points):
			door.is_locked = false
			GRH.points -= door.cost
		else:
			return
	
	GRH.emit_signal("door_entered", door)

	
