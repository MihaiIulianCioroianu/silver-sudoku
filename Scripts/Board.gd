extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const NUMBERTILE = preload("res://Nodes/NumberTile.tscn")
const SUDOKUBOARD = preload("res://Nodes/SudokuBoard.tscn")
var ins
var selected = Vector2(0, 0)
var sudokuID = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	AddTiles()
	AddTestBoard()
	Refresh()


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
		CurrentSudoku().ResetBoard()
		Refresh()
	if (kinput in range(10)):
		UpdateTile(kinput)

func AddTestBoard():
	ins = SUDOKUBOARD.instance()
	ins.name = "SudokuBoard0"
	$SudokuBoards.add_child(ins)
	sudokuID = 0

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
			currentTile.SetNumber(currentBoard[line][column])

# TILE GETTERS
func GetTile(address):
	return get_node("Tiles/NumberTile-"+str(address.x)+str(address.y))

func SelectedTile():
	return get_node("Tiles/NumberTile-"+str(selected.x)+str(selected.y))

func CurrentSudoku():
	return get_node("SudokuBoards/SudokuBoard"+str(sudokuID))

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
		for i in checkResult:
			GetTile(i).FlashRed()

# SIGNAL CATCHERS
func _on_tile_pressed(address):
	SelectedTile().Deactivate()
	selected = address
	GetTile(address).Activate()
