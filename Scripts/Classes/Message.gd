# MESSAGE
class_name Message
extends Node

# VARIABLES
var window_size = Vector2(300, 50)
var lines = []

func _init(size:Vector2, lineset:PoolStringArray):
	window_size = size
	lines = lineset
