extends Control

# Menu Related Nodes
@onready var menu : Control = $MarginContainer/VBoxContainer/Menu
@onready var menu_open_button : Button = $MarginContainer/VBoxContainer/MarginContainer/MenuOpenButton

# Button Containers
@onready var prev_countainer : Container = $MarginContainer/VBoxContainer/Menu/VBoxContainer/PrevCountainer
@onready var reset_container : Container = $MarginContainer/VBoxContainer/Menu/VBoxContainer/ResetContainer
@onready var quit_container : Container = $MarginContainer/VBoxContainer/Menu/VBoxContainer/QuitContainer

var game_has_won : bool = false

func _ready() -> void:
	GRH.connect("game_won", Callable(self, "_on_game_won"))
	menu.hide()

func _input(event: InputEvent) -> void:
	## Update the state of buttons every left-mouse click 
	## (Left mouse click implies the player is interacting with the game directly)
	if event.is_action_pressed("ui_accept"):
		if !(GRH.prev_rooms.is_empty() or game_has_won):
			prev_countainer.show()
			
		if GRH.prev_rooms.size() >= 1:
			# Show reset button once progressed past first room
			reset_container.show()

func _on_menu_open_button_toggled(toggled_on: bool) -> void:
	## Toggle to show and hide menu
	if toggled_on:
		menu.show()
	else:
		menu.hide()

func _on_prev_button_pressed() -> void:
	GRH.emit_signal("go_prev_room")
	
	if GRH.prev_rooms.is_empty() or game_has_won:
		prev_countainer.hide()
	
func _on_reset_button_pressed() -> void:
	menu_open_button.toggled.emit(false) # this hides the menu after reset
	game_has_won = false # If resetting level on game won screen, this sets it back to false
	
	GRH.emit_signal("game_reset")
	
	if GRH.prev_rooms.size() < 1:
		reset_container.hide()

func _on_quit_button_pressed() -> void:
	GRH.emit_signal("game_leave")

func _on_game_won() -> void:
	prev_countainer.hide()
	game_has_won = true
