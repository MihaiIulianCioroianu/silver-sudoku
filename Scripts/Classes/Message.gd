extends Node

class_name Message

var windowSize = Vector2(300, 50)
var lines = []

func _init(size:Vector2, lineset:PoolStringArray):
	windowSize = size
	lines = lineset
