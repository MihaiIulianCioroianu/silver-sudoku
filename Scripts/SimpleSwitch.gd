# SIMPLE SWITCH
class_name SimpleSwitch
extends Node2D

# SIGNALS
signal setting_change(setting, value)
# EXPORTED VARIABLES
@export var setting_name = ""
@export var label = ""
@export var current_value = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = label
	$TextureButton.set_pressed_no_signal(current_value)

func refresh(settings):
	$TextureButton.set_pressed_no_signal(settings[setting_name])

func _on_pressed(button_pressed):
	emit_signal("setting_change", setting_name, button_pressed)
