# SIMPLE BUTTON
class_name SimpleButton
extends Node2D

# SIGNALS
signal setting_button(setting)
# EXPORTED VARIABLES
@export var setting_name = ""
@export var label = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = label

func refresh(settings):
	pass

func _on_pressed():
	emit_signal("setting_button", setting_name)
