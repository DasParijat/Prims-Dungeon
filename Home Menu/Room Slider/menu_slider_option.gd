class_name MenuSliderOption
extends Control

@export var NAME : String
@export var SLIDER : Range

@onready var slider_name_label : Label = $"HBoxContainer/Slider Name"
@onready var slider_value_label : Label = $"HBoxContainer/Slider Value"


func _ready() -> void:
	slider_name_label.text = NAME
	update_text(GRH.num_of_rooms)
	
func update_text(new_value) -> void:
	slider_value_label.text = str(new_value)
	GRH.num_of_rooms = int(new_value)
	
func _on_h_slider_value_changed(value : float) -> void:
	update_text(value)
