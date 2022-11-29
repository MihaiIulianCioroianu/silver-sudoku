extends "res://Scripts/SystemFunctions.gd"
class_name Board

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const NUMBERTILE = preload("res://Nodes/NumberTile.tscn")
const SUDOKUBOARD = preload("res://Nodes/SudokuBoard.tscn")
var ins
var selected = Vector2(0, 0)
var sudokuNewID = 0
var sudokuID = 1
var sudokuList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	AddTiles()
	UpdateBoardNumberDisplay()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# INPUT EVENT
func _input(event):
	var kinput = -1;
	if event.is_action_pressed("1"):
		kinput = 1
	elif event.is_action_pressed("2"):
		kinput = 2
	elif event.is_action_pressed("3"):
		kinput = 3
	elif event.is_action_pressed("4"):
		kinput = 4
	elif event.is_action_pressed("5"):
		kinput = 5
	elif event.is_action_pressed("6"):
		kinput = 6
	elif event.is_action_pressed("7"):
		kinput = 7
	elif event.is_action_pressed("8"):
		kinput = 8
	elif event.is_action_pressed("9"):
		kinput = 9
	elif event.is_action_pressed("BACKSPACE"):
		kinput = 0
	elif event.is_action_pressed("RESET"):
		resetBoard()
	elif event.is_action_pressed("CHECK"):
		if CurrentSudoku().CheckBoardDone():
			for i in range(81):
				GetTile(Vector2(i%9, i/9)).FlashBlue()
		else:
			print("Nope")
	elif event.is_action_pressed("ui_left"):
		PreviousBoard()
	elif event.is_action_pressed("ui_right"):
		NextBoard()
	if (kinput in range(10)):
		UpdateTile(kinput)

# BOARD ADDING
func AddTestBoard():
	ins = SUDOKUBOARD.instance()
	ins.name = "SudokuBoard0"
	$SudokuBoards.add_child(ins)
	sudokuNewID += 1

func dict2sudoku(dict):
	return Sudoku.new(dict["id"], dict["sudokuName"], dict["format"], dict["data"])

func LoadBoard(boardData):
	sudokuList.append(dict2sudoku(boardData))
	sudokuNewID += 1

# BOARD LOADING
func NextBoard():
	if sudokuID < sudokuNewID - 1:
		sudokuID += 1
		Refresh()
		UpdateBoardNumberDisplay()
		saveBoardLocation()

func PreviousBoard():
	if sudokuID>0:
		sudokuID -=1
		Refresh()
		UpdateBoardNumberDisplay()
		saveBoardLocation()

func UpdateBoardNumberDisplay():
	get_parent().UpdateBoardNumber(sudokuID)

func AddTiles():
	for i in range(81):
		ins = NUMBERTILE.instance()
		ins.position.x = 3+(i%9)*50+3*((i%9)/3)
		ins.position.y = 3+(i/9)*50+3*(i/27)
		ins.address.x = i/9
		ins.address.y = i%9
		ins.name = "NumberTile-"+str(i/9)+str(i%9)
		$Tiles.add_child(ins)
		get_node("Tiles/NumberTile-"+str(i/9)+str(i%9)).connect("TilePressed", self, "_on_tile_pressed")

func Refresh():
	var currentTile
	var currentBoard = CurrentBoard()
	for line in range(9):
		for column in range(9):
			currentTile = get_node("Tiles/NumberTile-"+str(line)+str(column))
			if OriginalBoard()[line][column] != 0:
				currentTile.block()
			else:
				currentTile.unblock()
			currentTile.SetNumber(currentBoard[line][column])

func resetBoard():
	CurrentSudoku().ResetBoard()
	Refresh()

# TILE GETTERS
func GetTile(address):
	return get_node("Tiles/NumberTile-"+str(address.x)+str(address.y))

func SelectedTile():
	return get_node("Tiles/NumberTile-"+str(selected.x)+str(selected.y))

func CurrentSudoku():
	return sudokuList[sudokuID]

func CurrentBoard():
	return CurrentSudoku().GetBoard()

func OriginalBoard():
	return CurrentSudoku().GetOriginalBoard()

# TILE SETTERS
func UpdateTile(kinput):
	if not OriginalBoard()[selected.x][selected.y]:
		SelectedTile().SetNumber(kinput)
		CurrentSudoku().ChangeTile(selected, kinput)
		CheckBoardValid()

# CHECKER
func CheckBoardValid():
	var checkResult = CurrentSudoku().CheckBoardValidity()
	if (checkResult.empty()):
		pass
	else:
		if checkSetting("realTimeCorrection"):
			for i in checkResult:
				GetTile(i).FlashRed()

# SIGNAL CATCHERS
func _on_tile_pressed(address):
	SelectedTile().Deactivate()
	selected = address
	GetTile(address).Activate()

# SAVE BOARD LOCATION
func saveBoardLocation():
	get_parent().saveBoardLocation(sudokuID)

func checkSetting(settingName):
	return get_parent().settings[settingName]
