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
	var to_return = get_current_action()
	if pointer > 0:
		pointer -= 1
	return to_return

func redo():
	if pointer+1 < history.size():
		pointer += 1
	return get_current_action()

# SUBLIMATION-DEPOSITION
func sublimate():
	var sublimated_history = []
	for i in history:
		sublimated_history.append(i.sublimate())
	var to_return = inst_to_dict(self)
	to_return["history"] = sublimated_history
	return to_return

func deposit(dict):
	history = []
	for i in dict["history"]:
		history.append(dict2action(i))
	pointer = dict["pointer"]

func dict2action(dict):
	if typeof(dict) == TYPE_DICTIONARY:
		return SimpleSudokuAction.new(dict["address"], dict["previous_value"], dict["actual_value"])
	else:
		return 0

# GETTER
func get_current_action():
	return history[pointer]


# TOSTRING
func _to_string():
	var string_to_return = ""
	string_to_return += "History:\n"
	for i in range(0, history.size()):
		string_to_return += str(history[i])
		if i == pointer:
			string_to_return += " <--"
		string_to_return += "\n"
	string_to_return += "Current:\n"
	string_to_return += str(history[pointer])
	return string_to_return
