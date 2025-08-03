extends Node

const HOME_MENU : String = "uid://bhmlycafuc6t8"
const GAME : String = "uid://dktjfoar41ceu"

func change_scene(new_scene : String) -> void:
	get_tree().change_scene_to_file(new_scene)
