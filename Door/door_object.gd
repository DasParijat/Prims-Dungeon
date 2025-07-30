extends Control

@onready var button : Button = $"."
@onready var texture : TextureRect = $TextureRect
@onready var cost : Label = $CenterContainer/Cost

@onready var door : Door
@onready var cur_room : Room

func _ready() -> void:
	GRH.connect("door_entered", Callable(self, "_on_door_entered"))
	
	var connected_room : Room = door.room1 if door.room2 == cur_room else door.room2
	
	if door.is_locked:
		texture.texture = preload("uid://c2g24fa0tauir") if !connected_room.orb_found else preload("uid://cd2ym241n674i")
		cost.text = str(door.cost)
	else:
		texture.texture = preload("uid://7gfggwe3vnl2")
		cost.text = connected_room.letter_id

func _on_pressed() -> void:
	if door.is_locked:
		if door.unlock(GRH.points):
			door.is_locked = false
			GRH.points -= door.cost
			texture.texture = preload("uid://7gfggwe3vnl2")
			cost.text = door.room2.letter_id
		else:
			return
	
	GRH.emit_signal("door_entered", door)

	
