extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const NUMBERTILE = preload("res://Nodes/NumberTile.tscn")
var ins
var currentBoard = [
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

# Called when the node enters the scene tree for the first time.
func _ready():
	AddTiles()
	Refresh()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func AddTiles():
	for i in range(81):
		ins = NUMBERTILE.instance()
		ins.position.x = 3+(i%9)*50+3*((i%9)/3)
		ins.position.y = 3+(i/9)*50+3*(i/27)
		ins.address.x = i/9
		ins.address.y = i%9
		ins.name = "NumberTile-"+str(i/9)+str(i%9)
		$Tiles.add_child(ins)

func ImportCurrentBoard():
	currentBoard = []
	for i in get_parent().GetBoard():
		currentBoard.append(i.duplicate())
	Refresh()

func Refresh():
	var currentTile
	for line in range(9):
		for column in range(9):
			currentTile = get_node("Tiles/NumberTile-"+str(line)+str(column))
			currentTile.SetNumber(currentBoard[line][column])
