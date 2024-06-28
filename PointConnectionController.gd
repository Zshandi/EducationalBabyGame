extends Node2D

var points:Array[ConnectablePoint] = []
var connected_points:Array[ConnectablePoint] = []

func _ready():
	for child in get_children():
		if child is ConnectablePoint:
			points.push_back(child)

func clear_points():
	connected_points.clear()
	for point in points:
		point.is_connected = false

func _on_touch_input_primary_touch_event(event:, longest_touched_point):
	if longest_touched_point == null:
		clear_points()
		return
	
	for point in points:
		if point.is_connected:
			continue
		
		if point.is_pressed(longest_touched_point.position):
			connected_points.push_back(point)
			point.is_connected = true
			break
