extends Node2D
class_name ResizeableWindow

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var targetSize = Vector2(300, 500)
export var currentSize = Vector2(41, 41)
export var speed = 1000
export var lines = []
const LINE = preload("res://Nodes/MessageWindowLine.tscn")
signal onClosed
var ins
var linesNotInitialised = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentSize.x < targetSize.x:
		currentSize.x = min(currentSize.x+delta*speed, targetSize.x)
		resizeWindow(currentSize)
	elif currentSize.y < targetSize.y:
		currentSize.y = min(currentSize.y+delta*speed, targetSize.y)
		resizeWindow(currentSize)
	elif linesNotInitialised:
		loadLines()

func loadLines():
	linesNotInitialised = false
	for i in lines:
		ins = LINE.instance()
		ins.text = i
		$VBoxContainer2.add_child(ins)

func resizeWindow(windowSize):
	$VBoxContainer.hide()
	$VBoxContainer2.hide()
	$VBoxContainer2.rect_min_size = windowSize
	$VBoxContainer.rect_min_size = windowSize
	$VBoxContainer/HBoxContainer.rect_min_size.x = windowSize.x
	$VBoxContainer/HBoxContainer/TextureButton2.rect_min_size.x = windowSize.x-40
	$VBoxContainer/HBoxContainer2.rect_min_size.x = windowSize.x
	$VBoxContainer/HBoxContainer2.rect_min_size.y = windowSize.y-40
	$VBoxContainer/HBoxContainer2/TextureButton.rect_min_size.y = windowSize.y-40
	$VBoxContainer/HBoxContainer2/TextureButton2.rect_min_size.y = windowSize.y-40
	$VBoxContainer/HBoxContainer2/ColorRect.rect_min_size = windowSize - Vector2(40, 40)
	$VBoxContainer/HBoxContainer3.rect_min_size.x = windowSize.x
	$VBoxContainer/HBoxContainer3/TextureButton2.rect_min_size.x = windowSize.x-40
	$VBoxContainer.show()
	$VBoxContainer2.show()

func _close():
	emit_signal("onClosed")
	queue_free()
