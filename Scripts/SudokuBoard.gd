extends "res://Scripts/SystemFunctions.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var board = []
var originalBoard = []


# Called when the node enters the scene tree for the first time.
func _ready():
	InitialiseCleanBoard()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# BOARD INITIALISATION
func InitialiseCleanBoard():
	board = [
		[1, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 2, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 3, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 4, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 5, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 6, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 7, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 8, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 9],
		]
	originalBoard = [
		[1, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 2, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 3, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 4, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 5, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 6, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 7, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 8, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 9],
		]

# BOARD CHECKS
func CheckBoardDone():
	return (CheckBoardCompleteness() && CheckBoardValidity())

func CheckBoardCompleteness():
	for i in board:
		if 0 in i:
			return false
	return true

func CheckBoardValidity():
	for i in range(9):
		if not CheckLineValidity(i):
			return false
		if not CheckColumnValidity(i):
			return false
		if not CheckSquareValidity(i/3, i%3):
			return false
	return true

func CheckGO9Validity(go9):
	var symbolCounts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	for i in go9:
		symbolCounts[i] += 1
	symbolCounts[0] = 0
	for i in symbolCounts:
		if i>1:
			return false
	return true

func CheckLineValidity(lineNumber):
	return CheckGO9Validity(board[lineNumber])

func CheckColumnValidity(columnNumber):
	var column = []
	for i in board:
		column.append(i[columnNumber])
	return CheckGO9Validity(column)

func CheckSquareValidity(squareX, squareY):
	var square = []
	for i in range(squareX*3, squareX*3+2):
		for j in range(squareY*3, squareY*3+2):
			square.append(board[i][j])
	return CheckGO9Validity(square)

# GETTER
func GetBoard():
	return DuplicateBoard(board)

func GetOriginalBoard():
	return DuplicateBoard(originalBoard)

# LOADER/SAVER
func UpdateBoard(newBoard):
	board = newBoard

func ChangeTile(address, value):
	pass



