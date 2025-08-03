extends Control
class_name HomeMenu

func _on_play_button_pressed() -> void:
	GScene.change_scene(GScene.GAME)
