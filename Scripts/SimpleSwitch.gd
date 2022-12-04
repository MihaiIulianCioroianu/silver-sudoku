extends Node2D
class_name SimpleSwitch

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var settingName = ""
export var label = ""
export var currentValue = true
signal settingChange(setting, value)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = label
	$TextureButton.set_pressed_no_signal(currentValue)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func refresh(settings):
	$TextureButton.set_pressed_no_signal(settings[settingName])

func _on_pressed(button_pressed):
	emit_signal("settingChange", settingName, button_pressed)
