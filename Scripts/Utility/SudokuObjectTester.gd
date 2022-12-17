# SUDOKU OBJECT TESTER (DEPRECATED)
class_name SudokuObjectTester
extends Node

# VARIABLES
var test_object

# Called when the node enters the scene tree for the first time.
func _ready():
	test_object = Sudoku.new(1001, 
	"test_object", 
	Sudoku.FORMAT.X9, 
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
	]
	)
	print(test_object)
	test_object.ChangeTile(Vector2(0, 0), 8)
	test_object.ChangeTile(Vector2(0, 1), 1)
	print(test_object)
	print(test_object.CheckBoardValidity())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
