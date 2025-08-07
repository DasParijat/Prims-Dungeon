extends Control

const MENU_SCENE : PackedScene = preload("uid://bhmlycafuc6t8")

@onready var menu : Control = $MarginContainer/VBoxContainer/Menu
@onready var menu_open_button : Button = $MarginContainer/VBoxContainer/MarginContainer/MenuOpenButton

@onready var prev_countainer : Container = $MarginContainer/VBoxContainer/Menu/VBoxContainer/PrevCountainer
@onready var reset_container : Container = $MarginContainer/VBoxContainer/Menu/VBoxContainer/ResetContainer
@onready var quit_container : Container = $MarginContainer/VBoxContainer/Menu/VBoxContainer/QuitContainer

var game_has_won : bool = false

func _ready() -> void:
	GRH.connect("game_won", Callable(self, "_on_game_won"))
	menu.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if !(GRH.prev_rooms.is_empty() or game_has_won):
			prev_countainer.show()
			
		if GRH.prev_rooms.size() >= 1:
			reset_container.show()

func _on_menu_open_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		menu.show()
	else:
		menu.hide()

func _on_prev_button_pressed() -> void:
	GRH.emit_signal("go_prev_room")
	
	if GRH.prev_rooms.is_empty() or game_has_won:
		prev_countainer.hide()
	
func _on_reset_button_pressed() -> void:
	menu_open_button.toggled.emit(false)
	game_has_won = false
	
	GRH.emit_signal("game_reset")
	
	if GRH.prev_rooms.size() < 1:
		reset_container.hide()

func _on_quit_button_pressed() -> void:
	GRH.emit_signal("game_leave")

func _on_game_won() -> void:
	prev_countainer.hide()
	game_has_won = true
