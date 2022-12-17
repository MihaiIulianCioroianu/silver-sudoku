# STTINGS TRAY
class_name SettingsTray
extends Node2D

# SIGNALS
signal setting_change(setting, value)
signal button_pressed(setting)
# VARIABLES
var maximum_movement = 75 # max 105
var minimum_movement = 20
var movement = Vector2.ZERO
var speed = 150
var new_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(0, 20)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	new_position = position+(movement*speed)*delta
	if new_position.y>maximum_movement:
		new_position.y = maximum_movement
	elif new_position.y<minimum_movement:
		new_position.y = minimum_movement
	position = new_position
	if movement == Vector2.DOWN:
		if get_global_mouse_position().y > position.y+25:
			movement = Vector2.UP
		elif get_global_mouse_position().y < position.y-85:
			movement = Vector2.UP

func refresh(settings):
	for i in $Switches.get_children():
		i.refresh(settings)

func _on_Area2D_mouse_entered():
	movement = Vector2.DOWN


func setting_change(setting, value):
	emit_signal("setting_change", setting, value)


func button_pressed(setting):
	emit_signal("button_pressed", setting)
