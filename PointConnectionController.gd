extends Node2D

var points:Array[ConnectablePoint] = []
var connected_points:Array[ConnectablePoint] = []
var connected_lines:Array[CappedLine] = []

var current_line:CappedLine = null

var completing_shape := false

@onready
var line_container = $LineContainer

func _ready():
	for child in get_children():
		if child is ConnectablePoint:
			points.push_back(child)

func clear():
	connected_points.clear()
	for point in points:
		point.is_connected = false
	
	connected_lines.clear()
	current_line = null
	for line in line_container.get_children():
		line.queue_free()

func complete_shape(point:ConnectablePoint):
	completing_shape = true
	
	# Connect the current line to the point
	current_line.to = point.global_position
	
	# Remove all points & lines before the one that was connected to
	while !connected_points.is_empty() && connected_points[0] != point:
		connected_points[0].is_connected = false
		connected_lines[0].queue_free()
		connected_points.pop_front()
		connected_lines.pop_front()
	
	#TODO: Add timer and/or animation etc.

func _on_touch_input_primary_touch_event(event, longest_touched_point):
	
	if longest_touched_point == null:
		# Always clear when touch released
		clear()
		#TODO: Temp for debug
		completing_shape = false
		return
	
	if completing_shape:
		# We don't allow any interaction while completing the shape
		return
	
	# Check if each point is affected by touch
	for point in points:
		if point.is_pressed(longest_touched_point.position):
			
			# Check that the point isn't already connected
			if point.is_connected:
				if point == connected_points[-1] || point == connected_points[-2]:
					# Just interacting with last added point,
					# or one before  it (which would just make a line)
					continue
				else:
					# This connection completes a shape (probably)
					complete_shape(point)
					# Note: MUST return to avoid resetting current_line.to
					return
			
			# Point is not yet connected, so just connect it
			connect_point(point)
			break
	
	# Update the current line to follow the cursor
	if current_line != null:
		current_line.to = longest_touched_point.position

func connect_point(point:ConnectablePoint):
	point.is_connected = true
	connected_points.push_back(point)
	if current_line != null:
		current_line.to = point.position
	current_line = add_line(point.position)
	connected_lines.push_back(current_line)

func add_line(from:Vector2) -> CappedLine:
	var line = CappedLine.create(from, Vector2.ZERO, 20, Color.WHITE, true)
	line.owner = owner
	line_container.add_child(line)
	return line
