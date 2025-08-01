class_name MenuSliderOption
extends Control

@export var NAME : String
@export var RANGE : Range

@onready var slider_name_label : Label = $"HBoxContainer/Slider Name"
@onready var slider_value_label : Label = $"HBoxContainer/Slider Value"


func _ready() -> void:
	slider_name_label.text = NAME
