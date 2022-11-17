extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var boardsToLoad = [
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
var id = 1
var f
var boardData

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in boardsToLoad:
		boardData = ""
		f = File.new()
		f.open("user://SudokuBoard"+str(id)+".sdk", File.WRITE)
		print(f.get_path())
		print("X")
		print(f.get_position())
		for j in i:
			for k in j:
				boardData += str(k)
		f.store_pascal_string(boardData)
		f.close()
		print(f.get_path())
		id+=1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
