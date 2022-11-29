extends Node2D
class_name SimpleButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var settingName = ""
export var label = ""
signal settingButton(setting)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = label


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_pressed():
	print("X")
	emit_signal("settingButton", settingName)
