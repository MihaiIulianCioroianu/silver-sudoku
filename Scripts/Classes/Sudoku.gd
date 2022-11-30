
extends "res://Scripts/SystemFunctions.gd"
class_name Sudoku

enum FORMAT {X9=9, X6=6, X4=4, HEX=16}
var id:int
var sudokuName:String
var format:int
var data = []
var modifiedData = []
var timer:float

# BUILDER
func _init(bid:int, bsudokuName:String, bformat:int, bdata, btimer:float = 0, bmodifiedData = []):
	id = bid
	sudokuName = bsudokuName
	format = bformat
	data = DuplicateBoard(bdata)
	modifiedData = DuplicateBoard(bmodifiedData)
	if modifiedData.empty():
		modifiedData = DuplicateBoard(bdata)
	timer = btimer

# TOSTRING
func formatToString(formatCode):
	match formatCode:
		9:
			return "9X9"
		6:
			return "6X6"
		4:
			return "4X4"
		16:
			return "HEX"

func _to_string():
	var stringToReturn = ""
	stringToReturn += "Board ID "+str(id)+" "+"<<"+sudokuName+">>"+"\n"
	stringToReturn += "Format: "+formatToString(format)+"\n"
	stringToReturn += "Timer: "+str(timer)+"\n"
	if format == FORMAT.X9:
		for i in modifiedData:
			stringToReturn += str(i)+"\n"
	return stringToReturn

# BOARD CHECKS
func CheckBoardDone():
	return (CheckBoardCompleteness() and (CheckBoardValidity().empty()))

func CheckBoardCompleteness():
	if format in [FORMAT.X9, FORMAT.X6, FORMAT.X4, FORMAT.HEX]:
		for i in modifiedData:
			if 0 in i:
				return false
		return true
	return false

func CheckBoardValidity():
	var checkResult = []
	if format == FORMAT.X9:
		for i in range(9):
			checkResult.append_array(CheckLineValidity(i))
			checkResult.append_array(CheckColumnValidity(i))
			checkResult.append_array(CheckSquareValidity(i/3, i%3))
		return checkResult
	return checkResult

func CheckGroupValidity(group):
	var symbolCounts = []
	for i in range(0, format+1):
		symbolCounts.append(0)
	for i in group:
		symbolCounts[i] += 1
	symbolCounts[0] = 0
	for i in symbolCounts:
		if i>1:
			return false
	return true

func CheckLineValidity(lineNumber):
	var checkResult = []
	if CheckGroupValidity(modifiedData[lineNumber]):
		pass
	else:
		for i in FindDuplicates(modifiedData[lineNumber]):
			checkResult.append(Vector2(lineNumber, i))
	return checkResult

func CheckColumnValidity(columnNumber):
	var column = []
	for i in modifiedData:
		column.append(i[columnNumber])
	var checkResult = []
	if CheckGroupValidity(column):
		pass
	else:
		for i in FindDuplicates(column):
			checkResult.append(Vector2(i, columnNumber))
	return checkResult

func CheckSquareValidity(squareX, squareY):
	var checkResult = []
	var square = []
	if format == FORMAT.X9:
		for i in range(squareX*3, squareX*3+3):
			for j in range(squareY*3, squareY*3+3):
				square.append(modifiedData[i][j])
		if CheckGroupValidity(square):
			pass
		else:
			for i in FindDuplicates(square):
				checkResult.append(Vector2(squareX*3+i/3, squareY*3+i%3))
	return checkResult

func FindDuplicates(group):
	var duplicatesFound = []
	for i in group:
		if i:
			if group.count(i)>1:
				for j in range(group.size()):
					if group[j] == i:
						duplicatesFound.append(j)
	return duplicatesFound

# GETTER
func GetBoard():
	return DuplicateBoard(modifiedData)

func GetOriginalBoard():
	return DuplicateBoard(data)

# LOADER/SAVER
func UpdateBoard(newBoard):
	modifiedData = newBoard

func ChangeTile(address, value):
	modifiedData[address.x][address.y] = value

func ResetBoard():
	modifiedData = DuplicateBoard(data)
	timer = 0

# TIMER
func advanceTime(delta):
	timer += delta
	return timer

func getTime():
	return timer
