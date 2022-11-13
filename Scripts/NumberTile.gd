extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var number = 0
export var null_value = 0
var selected = false
var address = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	CheckEmpty()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func CheckEmpty():
	if number == null_value:
		$Label.visible = false
	else:
		$Label.visible = true

func SetNumber(num):
	number = num
	$Label.text = str(num)
	CheckEmpty()

# ANIMATIONS
func FlashRed():
	$AnimationPlayer.play("FlashRed")

func FlashBlue():
	$AnimationPlayer.play("FlashBlue")

#SELECTION
func Activate():
	selected = true
	$AnimationPlayer.play("Pulse")
