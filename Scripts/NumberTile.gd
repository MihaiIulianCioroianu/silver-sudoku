extends Node2D
class_name NumberTile

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal TilePressed
export var number = 0
export var null_value = 0
export var blocked = false
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

func Deactivate():
	selected = false
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET")

func _on_Tile_pressed():
	emit_signal("TilePressed", address)

# BLOCKING

func block():
	blocked = true
	$TextureButton.disabled = true

func unblock():
	blocked = false
	$TextureButton.disabled = false
