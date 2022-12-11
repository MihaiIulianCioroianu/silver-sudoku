# SYSTEM FUNCTIONS
class_name SystemFunctions
extends Node

func duplicate_board(board):
	var new_board = []
	for i in board:
		new_board.append(i.duplicate())
	return new_board
