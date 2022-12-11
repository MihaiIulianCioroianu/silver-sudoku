# RESIZEABLE WINDOW
class_name ResizeableWindow
extends Node2D

# SIGNALS
signal window_closed
# CONSTANTS
const LINE = preload("res://Nodes/MessageWindowLine.tscn")
# EXPORTED VARIABLES
export var target_size = Vector2(300, 500)
export var current_size = Vector2(41, 41)
export var speed = 1000
export var lines = []
# VARIABLES
var lines_not_initialised = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_size.x < target_size.x:
		current_size.x = min(current_size.x+delta*speed, target_size.x)
		resize_window(current_size)
	elif current_size.y < target_size.y:
		current_size.y = min(current_size.y+delta*speed, target_size.y)
		resize_window(current_size)
	elif lines_not_initialised:
		load_lines()

func load_lines():
	var ins
	lines_not_initialised = false
	for i in lines:
		ins = LINE.instance()
		ins.text = i
		$VBoxContainer2.add_child(ins)

func resize_window(window_size):
	$VBoxContainer.hide()
	$VBoxContainer2.hide()
	$VBoxContainer2.rect_min_size.x = max(0, window_size.x-10)
	$VBoxContainer.rect_min_size = window_size
	$VBoxContainer/HBoxContainer.rect_min_size.x = window_size.x
	$VBoxContainer/HBoxContainer/TextureButton2.rect_min_size.x = window_size.x-40
	$VBoxContainer/HBoxContainer2.rect_min_size.x = window_size.x
	$VBoxContainer/HBoxContainer2.rect_min_size.y = window_size.y-40
	$VBoxContainer/HBoxContainer2/TextureButton.rect_min_size.y = window_size.y-40
	$VBoxContainer/HBoxContainer2/TextureButton2.rect_min_size.y = window_size.y-40
	$VBoxContainer/HBoxContainer2/ColorRect.rect_min_size = window_size - Vector2(40, 40)
	$VBoxContainer/HBoxContainer3.rect_min_size.x = window_size.x
	$VBoxContainer/HBoxContainer3/TextureButton2.rect_min_size.x = window_size.x-40
	$VBoxContainer.show()
	$VBoxContainer2.show()

func _close():
	emit_signal("window_closed")
	queue_free()
