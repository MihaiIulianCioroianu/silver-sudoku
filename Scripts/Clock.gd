# CLOCK
class_name Clock
extends SystemFunctions
# DOCSTRING


# SIGNALS
# ENUMS
# CONSTANTS
const WEEKDAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
const MONTHS = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
# EXPORTED VARIABLES
# VARIABLES
var time_until_update = -1


func _ready():
	pass


func _process(delta):
	time_until_update -= delta
	if time_until_update < 0:
		var current_time = Time.get_datetime_dict_from_system()
		$Time.text = double_digit(current_time["hour"])+":"+double_digit(current_time["minute"])+":"+double_digit(current_time["second"])
		$Date.text = WEEKDAYS[current_time["weekday"]]+" "+double_digit(current_time["day"])+" "+MONTHS[current_time["month"]-1]
		time_until_update = 1.0
	
