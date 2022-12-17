# MESSAGES
class_name Messages
extends Node

# VARIABLES
var ABOUT = Message.new(Vector2(300, 120), ["ABOUT", "", "Silver Sudoku", "by Mihai Cioroianu 2022"])
var RULES = Message.new(Vector2(300, 240), ["RULES", "", 
"Select any white square and press a number 1-9 on your keyboard to set it. Complete the whole table so that no number appears twice in the same line, column or 3x3 square.", 
" ", "Press 0 or Backspace to delete.", "Press R to reset the board."])
var SHORTCUTS = Message.new(Vector2(300, 180), ["SHORTCUTS", "", "[Z] - Undo", "[X] - Redo", "[R] - Reset Board", "[LEFT] - Previous Board", "[RIGHT] - Next Board"])
