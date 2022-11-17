extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var monitoring = false
var dragging = false
var globalMousePosition
var mousePositionDifference
var f


# Called when the node enters the scene tree for the first time.
func _ready():
	LoadBoards()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		mousePositionDifference = globalMousePosition - get_global_mouse_position()
		OS.set_window_position(OS.get_window_position() - mousePositionDifference)

func LoadBoards():
	var files = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".sdk"):
			files.append(file)
	dir.list_dir_end()
	for i in files:
		f = File.new()
		f.open("user://"+i, File.READ)
		f.seek(0)
		$Board.LoadBoard(f.get_var())
		f.close()
	$Board.Refresh()

# BAR VIEWPORT
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			dragging = true
			globalMousePosition = get_global_mouse_position()
		elif event.button_index == 1 and not event.is_pressed():
			dragging = false

# BAR BUTTONS
func _on_MinimizeButton_pressed():
	OS.set_window_minimized(true)

func _on_CloseButton_pressed():
	get_tree().quit()
