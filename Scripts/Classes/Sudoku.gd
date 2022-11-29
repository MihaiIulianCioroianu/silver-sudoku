extends Node

class_name Sudoku

enum SUDOKU_FORMAT {FORMAT_9X9, FORMAT_6X6, FORMAT_4X4, FORMAT_HEX}
var id:int
var sudokuName:String
var format:int
var data

func _init(bid:int, bsudokuName:String, bformat:int, bdata):
	id = bid
	sudokuName = bsudokuName
	format = bformat
	data = bdata
