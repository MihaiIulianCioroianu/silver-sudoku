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
	originalBoard = [
		[0, 9, 0, 0, 0, 0, 3, 7, 5],
		[0, 0, 0, 1, 0, 7, 4, 0, 6],
		[6, 0, 7, 0, 9, 5, 1, 2, 8],
		[0, 0, 4, 8, 0, 1, 2, 5, 9],
		[2, 5, 0, 0, 4, 6, 0, 0, 1],
		[7, 0, 0, 5, 0, 2, 0, 8, 4],
		[4, 0, 6, 2, 8, 0, 5, 0, 3],
		[0, 0, 5, 7, 1, 4, 9, 6, 2],
		[0, 0, 1, 6, 5, 3, 8, 4, 7],
		]
	board = DuplicateBoard(originalBoard)

# BOARD CHECKS
func CheckBoardDone():
	return (CheckBoardCompleteness() and (CheckBoardValidity().empty()))

func CheckBoardCompleteness():
	for i in board:
		if 0 in i:
			return false
	return true

func CheckBoardValidity():
	var checkResult = []
	for i in range(9):
		checkResult.append_array(CheckLineValidity(i))
		checkResult.append_array(CheckColumnValidity(i))
		checkResult.append_array(CheckSquareValidity(i/3, i%3))
	return checkResult

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
	var checkResult = []
	if CheckGO9Validity(board[lineNumber]):
		pass
	else:
		for i in FindDuplicates(board[lineNumber]):
			checkResult.append(Vector2(lineNumber, i))
	return checkResult

func CheckColumnValidity(columnNumber):
	var column = []
	for i in board:
		column.append(i[columnNumber])
	var checkResult = []
	if CheckGO9Validity(column):
		pass
	else:
		for i in FindDuplicates(column):
			checkResult.append(Vector2(i, columnNumber))
	return checkResult

func CheckSquareValidity(squareX, squareY):
	var square = []
	for i in range(squareX*3, squareX*3+3):
		for j in range(squareY*3, squareY*3+3):
			square.append(board[i][j])
	var checkResult = []
	if CheckGO9Validity(square):
		pass
	else:
		for i in FindDuplicates(square):
			checkResult.append(Vector2(squareX*3+i/3, squareY*3+i%3))
	return checkResult

func FindDuplicates(go9):
	var duplicatesFound = []
	for i in go9:
		if i:
			if go9.count(i)>1:
				for j in range(9):
					if go9[j] == i:
						duplicatesFound.append(j)
	return duplicatesFound

# GETTER
func GetBoard():
	return DuplicateBoard(board)

func GetOriginalBoard():
	return DuplicateBoard(originalBoard)

# LOADER/SAVER
func UpdateBoard(newBoard):
	board = newBoard

func ChangeTile(address, value):
	board[address.x][address.y] = value

func ResetBoard():
	board = DuplicateBoard(originalBoard)

