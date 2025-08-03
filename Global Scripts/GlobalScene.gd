extends Node

const HOME_MENU : PackedScene = preload("res://Home Menu/home_menu.tscn")
const GAME : PackedScene = preload("res://Game/game.tscn")

func change_scene(new_scene : PackedScene) -> void:
	get_tree().change_scene_to_packed(new_scene)
