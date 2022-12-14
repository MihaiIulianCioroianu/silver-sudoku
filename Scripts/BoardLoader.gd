# BOARD LOADER
class_name BoardLoader
extends Node

# CONSTANTS
const BOARDS = [
	[
		[7, 0, 0, 3, 6, 0, 0, 1, 0],
		[1, 0, 0, 0, 5, 0, 9, 0, 0],
		[3, 0, 0, 0, 0, 8, 0, 0, 0],
		[4, 8, 0, 1, 0, 0, 0, 0, 5],
		[0, 1, 6, 0, 0, 0, 3, 8, 0],
		[2, 0, 0, 0, 0, 7, 0, 4, 1],
		[0, 0, 0, 9, 0, 0, 0, 0, 8],
		[0, 0, 2, 0, 4, 0, 0, 0, 9],
		[0, 4, 0, 0, 8, 3, 0, 0, 2],
	],
	[
		[8, 0, 0, 0, 5, 0, 0, 0, 0],
		[9, 0, 0, 2, 0, 4, 0, 3, 0],
		[0, 4, 0, 0, 7, 3, 0, 9, 0],
		[7, 0, 0, 0, 0, 0, 0, 0, 6],
		[5, 8, 3, 0, 0, 0, 2, 4, 7],
		[1, 0, 0, 0, 0, 0, 0, 0, 9],
		[0, 1, 0, 9, 6, 0, 0, 8, 0],
		[0, 9, 0, 5, 0, 2, 0, 0, 1],
		[0, 0, 0, 0, 4, 0, 0, 0, 2],
	],
	[
		[0, 7, 0, 3, 9, 5, 0, 4, 0],
		[0, 0, 9, 0, 0, 0, 0, 0, 0],
		[4, 0, 5, 0, 0, 6, 0, 1, 0],
		[0, 0, 0, 0, 7, 3, 0, 0, 9],
		[3, 6, 0, 0, 0, 0, 0, 7, 4],
		[9, 0, 0, 6, 8, 0, 0, 0, 0],
		[0, 2, 0, 5, 0, 0, 4, 0, 3],
		[0, 0, 0, 0, 0, 0, 6, 0, 0],
		[0, 5, 0, 9, 6, 4, 0, 8, 0],
	],
	[
		[5, 0, 0, 0, 0, 4, 0, 0, 7],
		[0, 7, 0, 0, 1, 0, 5, 0, 6],
		[0, 0, 2, 0, 0, 0, 9, 4, 0],
		[7, 8, 9, 3, 0, 0, 0, 0, 0],
		[0, 0, 0, 4, 8, 6, 0, 0, 0],
		[0, 0, 0, 0, 0, 7, 2, 3, 8],
		[0, 3, 5, 0, 0, 0, 1, 0, 0],
		[9, 0, 7, 0, 6, 0, 0, 5, 0],
		[8, 0, 0, 5, 0, 0, 0, 0, 2],
	],
]
const NAMES = [
	"",
	"Parting River",
	"Rising Hill",
	"Jumping Shrimp",
	"Crossroads"
]
# VARIABLES
var id = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var f
	var sudoku
	for i in BOARDS:
		sudoku = Sudoku.new(id, NAMES[id], Sudoku.FORMAT.X9, i, null)
		print(sudoku)
		f = File.new()
		f.open("user://SudokuBoard"+str(id)+".sdk", File.WRITE)
		f.store_var(inst2dict(sudoku))
		f.close()
		id+=1
	get_parent().load_boards()
