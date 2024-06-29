extends Node2D

var points:Array[ConnectablePoint] = []
var connected_points:Array[ConnectablePoint] = []

@onready
var line_container = $LineContainer

var current_line:DrawnLine = null

func _ready():
	for child in get_children():
		if child is ConnectablePoint:
			points.push_back(child)

func clear():
	connected_points.clear()
	for point in points:
		point.is_connected = false
	
	current_line = null
	for line in line_container.get_children():
		line.queue_free()

func _on_touch_input_primary_touch_event(event:, longest_touched_point):
	if longest_touched_point == null:
		clear()
		return
	
	for point in points:
		if point.is_connected:
			continue
		
		if point.is_pressed(longest_touched_point.position):
			connected_points.push_back(point)
			point.is_connected = true
			if current_line != null:
				current_line.to = point.position
			current_line = add_line(point.position)
			break
	
	if current_line != null:
		current_line.to = longest_touched_point.position

func add_line(from:Vector2) -> DrawnLine:
	var line = DrawnLine.create(from, Vector2.ZERO, 10, Color.WHITE, true)
	line.owner = owner
	line_container.add_child(line)
	return line
