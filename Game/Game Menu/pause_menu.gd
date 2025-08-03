extends Control

@onready var menu : Control = $Menu
@onready var menu_open_button : TextureButton = $MenuOpenButton

func _ready() -> void:
	menu.hide()

func _on_menu_open_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		menu.show()
	else:
		menu.hide()
