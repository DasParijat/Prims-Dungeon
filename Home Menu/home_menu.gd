extends Control
class_name HomeMenu

@onready var play_button : Button = $MarginContainer/VSplitContainer/MarginContainer/MarginContainer/PlayButton

func _on_play_button_pressed() -> void:
	## Set up loading information
	play_button.text = "Loading..."
	play_button.icon = null
	play_button.disabled = true
	
	# Reason for fake loading, is that there is a bit of lag
	# when it changes to game scene, so this timeout statement
	# allows the loading text to show and the lag seem like part of the loading
	await get_tree().create_timer(0.2).timeout
	
	GScene.change_scene(GScene.GAME)
