# GAME
class_name Game
extends Node2D

# CONSTANTS
const PAGE_SAVE = "user://PageLocation.uds"
const SETTING_SAVE = "user://Settings.uds"
const RESIZEABLE_WINDOW = preload("res://Nodes/ResizeableWindow.tscn")
const LEVEL_LOADER = preload("res://Nodes/BoardLoader.tscn")
# EXPORTED VARIABLES
export var window_size = 700
# UTILITIES
var _Messages = Messages.new()
# VARIABLES
var window_size_check = 700
var monitoring = false
var dragging = false
var global_mouse_position
var mouse_position_difference
var time_since_last_bar_click = 0
var window_scrolled = false
var settings = {
	"real_time_correction" : true,
	"hint_labels" : true
	}



# Called when the node enters the scene tree for the first time.
func _ready():
	var f
	load_boards()
	f = File.new()
	if f.file_exists(PAGE_SAVE):
		load_board_location()
	load_settings()
	refresh_settings_tray()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if window_size != window_size_check:
		window_size_check = window_size
		OS.set_window_size(Vector2(500, window_size_check))
	time_since_last_bar_click += delta
	if dragging:
		mouse_position_difference = global_mouse_position - get_global_mouse_position()
		OS.set_window_position(OS.get_window_position() - mouse_position_difference)

# BAR VIEWPORT
func _on_barPressed_down():
	dragging = true
	global_mouse_position = get_global_mouse_position()

func _on_barPressed_up():
	dragging = false
	if time_since_last_bar_click < 0.5:
		scroll_window()
		time_since_last_bar_click = 1
	else:
		time_since_last_bar_click = 0

# BAR BUTTONS
func update_board_number(number_to_update):
	$BoardSelector/Label.text = str(number_to_update)

func _on_MinimizeButton_pressed():
	minimize_window()

func minimize_window():
	OS.set_window_minimized(true)

func _on_CloseButton_pressed():
	close_window()

func close_window():
	get_tree().quit()

func scroll_window():
	window_scrolled = !window_scrolled
	if window_scrolled:
		$AnimationPlayer.play("Scroll")
	else:
		$AnimationPlayer.play("Descroll")

# SAVES
func load_boards():
	var ins
	var f
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
	if files.size() < 1:
		ins = LEVEL_LOADER.instance()
		add_child(ins)
	for i in files:
		f = File.new()
		f.open("user://"+i, File.READ)
		f.seek(0)
		$Board.load_board(f.get_var())
		f.close()
	$Board.refresh()

func save_board_location(sudoku_ID):
	var f
	f = File.new()
	f.open(PAGE_SAVE, File.WRITE)
	f.seek(0)
	f.store_var(sudoku_ID)

func load_board_location():
	var f
	f = File.new()
	f.open(PAGE_SAVE, File.READ)
	f.seek(0)
	var loaded_position = f.get_var()
	if loaded_position in range(0, 100000):
		$Board.sudoku_ID = loaded_position
	else:
		$Board.sudoku_ID = 1
	$Board.refresh()
	$Board.update_board_number_display()

func save_settings():
	var f
	f = File.new()
	f.open(SETTING_SAVE, File.WRITE)
	f.seek(0)
	print(settings)
	f.store_var(settings)

func load_settings():
	var f
	f = File.new()
	if f.file_exists(SETTING_SAVE):
		f.open(SETTING_SAVE, File.READ)
		f.seek(0)
		var settings_to_set = f.get_var()
		print(settings_to_set)
		if settings_to_set:
			settings = settings_to_set
		$Board.refresh()

# SETTINGS TRAY
func _on_settingChange(setting, value):
	settings[setting] = value
	$Board.refresh()
	save_settings()

func _on_trayButtonPressed(setting):
	if setting == "show_about":
		create_message(_Messages.ABOUT)
	elif setting == "reset_board":
		$Board.reset_board()
	elif setting == "show_rules":
		create_message(_Messages.RULES)
	elif setting == "show_shortcuts":
		create_message(_Messages.SHORTCUTS)
	elif "new_year" in setting:
		create_message(_Messages.NEW_YEAR)
	elif setting == "undo":
		$Board.undo()
	elif setting == "redo":
		$Board.redo()

func refresh_settings_tray():
	$SettingsTray.refresh(settings)

# UI
func activate_input_block():
	$InputBlock.visible = true

func deactivate_input_block():
	$InputBlock.visible = false

func create_message(message:Message):
	var ins
	activate_input_block()
	ins = RESIZEABLE_WINDOW.instance()
	ins.connect("window_closed", get_node("."), "deactivate_input_block")
	ins.target_size = message.window_size
	ins.lines = message.lines
	ins.position = (Vector2(500, 700)-message.window_size)/2
	$MessageLayer.add_child(ins)
