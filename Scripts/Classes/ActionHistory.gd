# ACTION HISTORY UNIVERSAL OBJECT
class_name ActionHistory
extends Node
# DOCSTRING


# SIGNALS
signal added_action()

# ENUMS

# CONSTANTS

# EXPORTED VARIABLES

# VARIABLES
var history = []
var pointer = -1


func _init(initial_action):
	history = [initial_action]
	pointer = 0


func _ready():
	pass


# ACTIONS
func add_action(action):
	if (pointer+1) < history.size():
		history.resize(pointer+1)
	history.append(action)
	pointer += 1

func undo():
	if pointer > 0:
		pointer -= 1
	return get_current_action()

func redo():
	if pointer+1 < history.size():
		pointer += 1
	return get_current_action()


# GETTER
func get_current_action():
	return history[pointer]

