extends Control

@onready var button : Button = $"."
@onready var texture : TextureRect = $TextureRect
@onready var cost : Label = $CenterContainer/Cost

@onready var door : Door
@onready var cur_room : Room

func _ready() -> void:
	GRH.connect("door_entered", Callable(self, "_on_door_entered"))
	
	if door.is_locked:
		texture.texture = preload("uid://c2g24fa0tauir")
		cost.text = str(door.cost)
	else:
		texture.texture = preload("uid://7gfggwe3vnl2")
		if door.room2 == cur_room:
			cost.text = door.room1.letter_id
		else:
			cost.text = door.room2.letter_id

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

	
