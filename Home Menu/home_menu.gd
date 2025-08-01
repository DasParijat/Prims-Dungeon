extends Control
class_name HomeMenu

const GAME_SCENE : PackedScene = preload("res://Game/game.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)
