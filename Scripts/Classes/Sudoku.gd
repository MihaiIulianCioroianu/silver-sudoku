# SUDOKU UNIVERSAL OBJECT
class_name Sudoku
extends "res://Scripts/SystemFunctions.gd"

# ENUMS
enum FORMAT {X9=9, X6=6, X4=4, HEX=16}
# VARIABLES
var object_version = 3
var id:int
var sudoku_name:String
var format:int
var data = []
var modified_data = []
var timer:float
var complete:bool
var history:ActionHistory


# BUILDER
func _init(_id:int, _sudoku_name:String, _format:int, _data, _history, _timer:float = 0, _modified_data = [], _complete = false):
	id = _id
	sudoku_name = _sudoku_name
	format = _format
	data = duplicate_board(_data)
	modified_data = duplicate_board(_modified_data)
	if modified_data.empty():
		modified_data = duplicate_board(_data)
	timer = _timer
	complete = _complete
	if _history == null:
		history = ActionHistory.new(SimpleSudokuAction.new(Vector2(0, 0), data[0][0], data[0][0]))
	elif typeof(_history) == TYPE_DICTIONARY:
		history = dict2history(_history)
	else:
		history = _history


# TOSTRING
func format2string(format_code):
	match format_code:
		9:
			return "9X9"
		6:
			return "6X6"
		4:
			return "4X4"
		16:
			return "HEX"

func _to_string():
	var string_to_return = ""
	string_to_return += "Board ID "+str(id)+" "+"<<"+sudoku_name+">>"+"\n"
	string_to_return += "Format: "+format2string(format)+" V"+str(object_version)+"\n"
	string_to_return += "Timer: "+str(timer)+"\n"
	if format == FORMAT.X9:
		for i in modified_data:
			string_to_return += str(i)+"\n"
	return string_to_return


# BOARD CHECKS
func check_board_done():
	if check_board_completeness():
		return check_board_validity().empty()
	else:
		return false

func check_board_completeness():
	if format in [FORMAT.X9, FORMAT.X6, FORMAT.X4, FORMAT.HEX]:
		for i in modified_data:
			if 0 in i:
				return false
		return true
	return false

func check_board_validity():
	var check_result = []
	if format == FORMAT.X9:
		for i in range(9):
			check_result.append_array(check_line_validity(i))
			check_result.append_array(check_column_validity(i))
			check_result.append_array(check_square_validity(Vector2(i/3, i%3)))
		return check_result
	return check_result

func check_group_validity(group):
	var symbol_counts = []
	for i in range(0, format+1):
		symbol_counts.append(0)
	for i in group:
		symbol_counts[i] += 1
	symbol_counts[0] = 0
	for i in symbol_counts:
		if i>1:
			return false
	return true

func check_line_validity(line_number):
	var check_result = []
	if check_group_validity(modified_data[line_number]):
		pass
	else:
		for i in find_duplicates(modified_data[line_number]):
			check_result.append(Vector2(line_number, i))
	return check_result

func check_column_validity(column_number):
	var column = []
	for i in modified_data:
		column.append(i[column_number])
	var check_result = []
	if check_group_validity(column):
		pass
	else:
		for i in find_duplicates(column):
			check_result.append(Vector2(i, column_number))
	return check_result

func check_square_validity(square_address):
	var check_result = []
	var square = []
	if format == FORMAT.X9:
		for i in range(square_address.x*3, square_address.x*3+3):
			for j in range(square_address.y*3, square_address.y*3+3):
				square.append(modified_data[i][j])
		if check_group_validity(square):
			pass
		else:
			for i in find_duplicates(square):
				check_result.append(Vector2(square_address.x*3+i/3, square_address.y*3+i%3))
	return check_result

func find_duplicates(group):
	var duplicates_found = []
	for i in group:
		if i:
			if group.count(i)>1:
				for j in range(group.size()):
					if group[j] == i:
						duplicates_found.append(j)
	return duplicates_found

func check_available_moves(address):
	var available_moves = []
	if format == FORMAT.X9:
		if not modified_data[address.x][address.y]:
			var errors_found = 0
			for i in range (1, 10):
				errors_found = 0
				change_tile(address, i)
				errors_found += check_line_validity(address.x).size()
				errors_found += check_column_validity(address.y).size()
				errors_found += check_square_validity(Vector2(int(address.x/3), int(address.y/3))).size()
				if errors_found == 0:
					available_moves.append(i)
			change_tile(address, 0)
	return available_moves

func set_complete():
	complete = true


# GETTER
func get_board():
	return duplicate_board(modified_data)

func get_original_board():
	return duplicate_board(data)

func get_title():
	return sudoku_name


# LOADER/SAVER
func update_board(new_board):
	modified_data = new_board

func change_tile(address, value):
	if complete and (modified_data[address.x][address.y] != value):
		complete = false
	modified_data[address.x][address.y] = value

func reset_board():
	modified_data = duplicate_board(data)
	timer = 0
	history = ActionHistory.new(SimpleSudokuAction.new(Vector2(0, 0), data[0][0], data[0][0]))
	complete = false

func to_dict():
	var to_return = inst2dict(self)
	to_return["history"] = history.sublimate()
	return to_return

func dict2history(dict):
	var to_return = ActionHistory.new(0)
	to_return.deposit(dict)
	return to_return

# TIMER
func advance_time(delta):
	if not complete:
		timer += delta
	return timer

func get_time():
	return timer


# HISTORY
func undo():
	var undo_result = history.undo()
	modified_data[undo_result.address.x][undo_result.address.y] = undo_result.previous_value

func redo():
	var redo_result = history.redo()
	modified_data[redo_result.address.x][redo_result.address.y] = redo_result.actual_value


