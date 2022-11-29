extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var testObject1

# Called when the node enters the scene tree for the first time.
func _ready():
	testObject1 = Sudoku.new(1001, 
	"TestObject1", 
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
	print(testObject1)
	testObject1.ChangeTile(Vector2(0, 0), 8)
	testObject1.ChangeTile(Vector2(0, 1), 1)
	print(testObject1)
	print(testObject1.CheckBoardValidity())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
