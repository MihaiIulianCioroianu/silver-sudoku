# MESSAGES
class_name Messages
extends Node

# VARIABLES
var ABOUT = Message.new(Vector2(300, 120), ["ABOUT", "", "Silver Sudoku", "by Mihai Cioroianu 2022"])
var RULES = Message.new(Vector2(300, 220), ["RULES", "", 
"Select any white square and press a number 1-9 on your keyboard to set it. Complete the whole table so that no number appears twice in the same line, column or 3x3 square.", 
" ", "Press 0 or Backspace to delete."])
var SHORTCUTS = Message.new(Vector2(300, 180), ["SHORTCUTS", "", "[Z] - Undo", "[X] - Redo", "[R] - Reset Board", "[LEFT] - Previous Board", "[RIGHT] - Next Board"])
var NEW_YEAR = Message.new(Vector2(300, 50), ["HAPPY NEW YEAR "])

func _init():
	NEW_YEAR.lines[0] += str(Time.get_date_dict_from_system()["year"])
