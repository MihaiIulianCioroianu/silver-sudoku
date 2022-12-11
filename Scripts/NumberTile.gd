# NUMBER TILE
class_name NumberTile
extends Node2D

# SIGNALS
signal tile_pressed
# EXPORTED VARIABLES
export var number = 0
export var null_value = 0
export var blocked = false
# VARIABLES
var selected = false
var hint_label = true
var address = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	check_empty()

# DISPLAY LOGIC
func check_empty():
	if number == null_value:
		$Label.visible = false
		$HintLabels.visible = hint_label
	else:
		$Label.visible = true
		$HintLabels.visible = false

func set_hint_labels(number_set):
	for i in $HintLabels.get_children():
		if int(i.name[9]) in number_set:
			i.visible = true
		else:
			i.visible = false

func set_number(new_number):
	number = new_number
	$Label.text = str(number)
	check_empty()

# ANIMATIONS
func flash_red():
	$AnimationPlayer.play("FlashRed")

func flash_blue():
	$AnimationPlayer.play("FlashBlue")

#SELECTION
func activate():
	selected = true
	$AnimationPlayer.play("Pulse")

func deactivate():
	selected = false
	$AnimationPlayer.stop()
	$AnimationPlayer.play("RESET")

func _on_Tile_pressed():
	emit_signal("tile_pressed", address)

# BLOCKING
func block():
	blocked = true
	$TextureButton.disabled = true

func unblock():
	blocked = false
	$TextureButton.disabled = false

# HINT LABEL
func enable_hint_label():
	hint_label = true
	check_empty()

func disable_hint_label():
	hint_label = false
	check_empty()
