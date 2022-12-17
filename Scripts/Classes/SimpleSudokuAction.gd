# SIMPLE SUDOKU ACTION
class_name SimpleSudokuAction
extends Node
# DOCSTRING


# SIGNALS
# ENUMS
# CONSTANTS
# EXPORTED VARIABLES
# VARIABLES
var address:Vector2
var previous_value
var actual_value


func _init(_address:Vector2, _previous_value, _actual_value):
	address = _address
	previous_value = _previous_value
	actual_value = _actual_value


func _ready():
	pass


# TOSTRING
func _to_string():
	return "ADR:"+str(address)+" PRV:"+str(previous_value)+" ACT:"+str(actual_value)

# SUBLIMATE
func sublimate():
	return inst2dict(self)
