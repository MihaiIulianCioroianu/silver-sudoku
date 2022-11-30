extends Node2D
class_name Game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var windowSize = 700
const PAGESAVE = "user://PageLocation.uds"
const RESWINDOW = preload("res://Nodes/ResizeableWindow.tscn")
var _Messages = Messages.new()
var windowSizeCheck = 700
var monitoring = false
var dragging = false
var globalMousePosition
var mousePositionDifference
var f
var ins
var timeSinceLastBarClick = 0
var windowScrolled = false
var settings = {
	"realTimeCorrection" : true
	}



# Called when the node enters the scene tree for the first time.
func _ready():
	LoadBoards()
	f = File.new()
	if f.file_exists(PAGESAVE):
		loadBoardLocation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if windowSize != windowSizeCheck:
		windowSizeCheck = windowSize
		OS.set_window_size(Vector2(500, windowSizeCheck))
	timeSinceLastBarClick += delta
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
func _on_barPressed_down():
	dragging = true
	globalMousePosition = get_global_mouse_position()

func _on_barPressed_up():
	dragging = false
	if timeSinceLastBarClick < 0.5:
		scrollWindow()
		timeSinceLastBarClick = 1
	else:
		timeSinceLastBarClick = 0

# BAR BUTTONS
func UpdateBoardNumber(numberToUpdate):
	$BoardSelector/Label.text = str(numberToUpdate)

func _on_MinimizeButton_pressed():
	minimizeWindow()

func minimizeWindow():
	OS.set_window_minimized(true)

func _on_CloseButton_pressed():
	closeWindow()

func closeWindow():
	get_tree().quit()

func scrollWindow():
	windowScrolled = !windowScrolled
	if windowScrolled:
		$AnimationPlayer.play("Scroll")
	else:
		$AnimationPlayer.play("Descroll")

# SAVES
func saveBoardLocation(sudokuID):
	f = File.new()
	f.open(PAGESAVE, File.WRITE)
	f.seek(0)
	f.store_var(sudokuID)

func loadBoardLocation():
	f = File.new()
	f.open(PAGESAVE, File.READ)
	f.seek(0)
	var loadedPosition = f.get_var()
	if loadedPosition in range(0, 100000):
		$Board.sudokuID = loadedPosition
	else:
		$Board.sudokuID = 1
	$Board.Refresh()
	$Board.UpdateBoardNumberDisplay()

# SETTINGS TRAY
func _on_settingChange(setting, value):
	settings[setting] = value

func _on_trayButtonPressed(setting):
	if setting == "showAbout":
		createMessage(_Messages.ABOUT)
	if setting == "resetBoard":
		$Board.resetBoard()

# UI
func activateInputBlock():
	$InputBlock.visible = true

func deactivateInputBlock():
	$InputBlock.visible = false

func createMessage(message:Message):
	activateInputBlock()
	ins = RESWINDOW.instance()
	ins.connect("onClosed", get_node("."), "deactivateInputBlock")
	ins.targetSize = message.windowSize
	ins.lines = message.lines
	ins.position = (Vector2(500, 700)-message.windowSize)/2
	$MessageLayer.add_child(ins)

