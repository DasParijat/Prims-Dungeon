extends Control

const MENU_SCENE : PackedScene = preload("uid://bhmlycafuc6t8")

@onready var menu : Control = $Menu
@onready var menu_open_button : TextureButton = $MenuOpenButton

func _ready() -> void:
	menu.hide()

func _on_menu_open_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		menu.show()
	else:
		menu.hide()

func _on_reset_button_pressed() -> void:
	menu_open_button.toggled.emit(false)
	
	GRH.emit_signal("game_reset")

func _on_quit_button_pressed() -> void:
	GRH.emit_signal("game_leave")
