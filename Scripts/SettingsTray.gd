extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maximumMovement = 105
var minimumMovement = 20
var movement = Vector2.ZERO
var speed = 150
var newPosition = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(0, 20)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	newPosition = position+(movement*speed)*delta
	if newPosition.y>maximumMovement:
		newPosition.y = maximumMovement
	elif newPosition.y<minimumMovement:
		newPosition.y = minimumMovement
	position = newPosition
	


func _on_Area2D_mouse_entered():
	movement = Vector2.DOWN


func _on_Area2D_mouse_exited():
	movement = Vector2.UP
