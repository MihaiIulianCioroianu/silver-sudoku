# ACTION HISTORY OBJECT TESTER
class_name ActionHistoryObjectTester
extends Node
# DOCSTRING


# SIGNALS
# ENUMS
# CONSTANTS
# EXPORTED VARIABLES
# VARIABLES

func _ready():
	var action = SimpleSudokuAction.new(Vector2(1, 2), 5, 2)
	var history = ActionHistory.new(action)
	print(history)
	history.add_action(SimpleSudokuAction.new(Vector2(1, 2), 2, 7))
	print(history)
	history.add_action(SimpleSudokuAction.new(Vector2(1, 2), 7, 1))
	print(history)
	history.undo()
	print(history)
	history.undo()
	print(history)
	history.redo()
	print(history)
