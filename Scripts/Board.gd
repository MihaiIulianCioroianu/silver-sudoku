# BOARD
class_name Board
extends "res://Scripts/SystemFunctions.gd"

# CONSTANTS
const NUMBER_TILE = preload("res://Nodes/NumberTile.tscn")
const SUDOKU_BOARD = preload("res://Nodes/SudokuBoard.tscn")
# VARIABLES
var selected = Vector2(0, 0)
var sudoku_new_ID = 0
var sudoku_ID = 1
var sudoku_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	add_tiles()
	update_board_number_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_timer_display(advance_time(delta))

# INPUT EVENT
func _input(event):
	var key_input = -1;
	if event.is_action_pressed("1"):
		key_input = 1
	elif event.is_action_pressed("2"):
		key_input = 2
	elif event.is_action_pressed("3"):
		key_input = 3
	elif event.is_action_pressed("4"):
		key_input = 4
	elif event.is_action_pressed("5"):
		key_input = 5
	elif event.is_action_pressed("6"):
		key_input = 6
	elif event.is_action_pressed("7"):
		key_input = 7
	elif event.is_action_pressed("8"):
		key_input = 8
	elif event.is_action_pressed("9"):
		key_input = 9
	elif event.is_action_pressed("BACKSPACE"):
		key_input = 0
	elif event.is_action_pressed("RESET"):
		reset_board()
	elif event.is_action_pressed("CHECK"):
		check_board_done()
	elif event.is_action_pressed("UNDO"):
		undo()
	elif event.is_action_pressed("REDO"):
		redo()
	elif event.is_action_pressed("ui_left"):
		previous_board()
	elif event.is_action_pressed("ui_right"):
		next_board()
	if (key_input in range(10)):
		update_tile(key_input)

# BOARD ADDING
func add_test_board():
	var ins
	ins = SUDOKU_BOARD.instance()
	ins.name = "SudokuBoard0"
	$SudokuBoards.add_child(ins)
	sudoku_new_ID += 1

func dict2sudoku(dict):
	var sudoku_to_return
	if ("object_version" in dict) and (dict["object_version"] == 3):
		# Object Version 3
		sudoku_to_return = Sudoku.new(dict["id"], dict["sudoku_name"], dict["format"], dict["data"], dict["history"], float(dict["timer"]), dict["modified_data"], bool(dict["complete"]))
	elif "complete" in dict:
		# Object Version 2
		sudoku_to_return = Sudoku.new(dict["id"], dict["sudoku_name"], dict["format"], dict["data"], null, float(dict["timer"]), dict["modified_data"], bool(dict["complete"]))
	else:
		# Object Version 1
		sudoku_to_return = Sudoku.new(dict["id"], dict["sudoku_name"], dict["format"], dict["data"], null, float(dict["timer"]), dict["modified_data"])
	return sudoku_to_return

func load_board(board_data):
	sudoku_list.append(dict2sudoku(board_data))
	sudoku_new_ID += 1

# BOARD LOADING
func next_board():
	save_board()
	if sudoku_ID < sudoku_new_ID - 1:
		sudoku_ID += 1
		refresh()
		update_board_number_display()
		save_board_location()

func previous_board():
	save_board()
	if sudoku_ID>0:
		sudoku_ID -=1
		refresh()
		update_board_number_display()
		save_board_location()

func update_board_number_display():
	get_parent().update_board_number(sudoku_ID)

func add_tiles():
	var ins
	for i in range(81):
		ins = NUMBER_TILE.instance()
		ins.position.x = 3+(i%9)*50+3*((i%9)/3)
		ins.position.y = 3+(i/9)*50+3*(i/27)
		ins.address.x = i/9
		ins.address.y = i%9
		ins.name = "NumberTile-"+str(i/9)+str(i%9)
		$Tiles.add_child(ins)
		get_node("Tiles/NumberTile-"+str(i/9)+str(i%9)).connect("tile_pressed", self, "_on_tile_pressed")

func refresh():
	var current_tile
	var current_board = current_board()
	$Title.text = current_sudoku().get_title()
	for line in range(9):
		for column in range(9):
			current_tile = get_node("Tiles/NumberTile-"+str(line)+str(column))
			if original_board()[line][column] != 0:
				current_tile.block()
			else:
				current_tile.unblock()
			current_tile.set_number(current_board[line][column])
	if get_parent().settings["hint_labels"]:
		enable_hint_labels()
		refresh_hint_labels()
	else:
		disable_hint_labels()
		refresh_hint_labels()

func reset_board():
	current_sudoku().reset_board()
	refresh()
	save_board()

func refresh_hint_labels():
	for i in range(0, 9):
		for j in range(0, 9):
			get_hint_labels(Vector2(i, j))

func get_hint_labels(address):
	get_tile(address).set_hint_labels(current_sudoku().check_available_moves(address))

func enable_hint_labels():
	for i in range(0, 9):
		for j in range(0, 9):
			get_tile(Vector2(i, j)).enable_hint_label()

func disable_hint_labels():
	for i in range(0, 9):
		for j in range(0, 9):
			get_tile(Vector2(i, j)).disable_hint_label()

# TILE GETTERS
func get_tile(address):
	return get_node("Tiles/NumberTile-"+str(address.x)+str(address.y))

func selected_tile():
	return get_node("Tiles/NumberTile-"+str(selected.x)+str(selected.y))

func current_sudoku():
	return sudoku_list[sudoku_ID]

func current_board():
	return current_sudoku().get_board()

func original_board():
	return current_sudoku().get_original_board()

# TILE SETTERS
func update_tile(key_input):
	var error_number
	if not original_board()[selected.x][selected.y]:
		current_sudoku().history.add_action(SimpleSudokuAction.new(selected, current_sudoku().modified_data[selected.x][selected.y], key_input))
		selected_tile().set_number(key_input)
		current_sudoku().change_tile(selected, key_input)
		error_number = check_board_valid()
		refresh()
	if error_number == 0:
		check_board_done()
	save_board()

# TIMER
func advance_time(delta):
	return current_sudoku().advance_time(delta)

func get_time():
	return current_sudoku().get_time()

func set_timer_display(timer):
	timer = int(timer)
	$Timer.text = "Time: "+double_digit(timer/3600)+":"+double_digit((timer%3600)/60)+":"+double_digit(timer%60)

# CHECKER
func check_board_done():
	if current_sudoku().check_board_done():
		current_sudoku().set_complete()
		for i in range(81):
			get_tile(Vector2(i%9, i/9)).flash_blue()

func check_board_valid():
	var check_result = current_sudoku().check_board_validity()
	if (check_result.empty()):
		return 0
	else:
		if check_setting("real_time_correction"):
			for i in check_result:
				get_tile(i).flash_red()
			return check_result.size()

# SIGNAL CATCHERS
func _on_tile_pressed(address):
	selected_tile().deactivate()
	selected = address
	get_tile(address).activate()

# SAVE BOARD INFO
func save_board_location():
	get_parent().save_board_location(sudoku_ID)

func check_setting(setting_name):
	return get_parent().settings[setting_name]

func save_board():
	var f
	f = File.new()
	f.open("user://SudokuBoard"+str(sudoku_ID+1)+".sdk", File.WRITE)
	f.store_var(current_sudoku().to_dict())
	f.close()

# UNDO-REDO
func undo():
	current_sudoku().undo()
	refresh()
	save_board()

func redo():
	current_sudoku().redo()
	refresh()
	save_board()
