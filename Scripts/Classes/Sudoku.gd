# SUDOKU UNIVERSAL OBJECT
class_name Sudoku
extends "res://Scripts/SystemFunctions.gd"

# ENUMS
enum FORMAT {X9=9, X6=6, X4=4, HEX=16}
# VARIABLES
var id:int
var sudoku_name:String
var format:int
var data = []
var modified_data = []
var timer:float

# BUILDER
func _init(bid:int, bsudoku_name:String, bformat:int, bdata, btimer:float = 0, bmodified_data = []):
	id = bid
	sudoku_name = bsudoku_name
	format = bformat
	data = duplicate_board(bdata)
	modified_data = duplicate_board(bmodified_data)
	if modified_data.empty():
		modified_data = duplicate_board(bdata)
	timer = btimer

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
	string_to_return += "Format: "+format2string(format)+"\n"
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
	modified_data[address.x][address.y] = value

func reset_board():
	modified_data = duplicate_board(data)
	timer = 0

# TIMER
func advance_time(delta):
	timer += delta
	return timer

func get_time():
	return timer
