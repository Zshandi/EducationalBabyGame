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
		point.reset()
	
	connected_lines.clear()
	current_line = null
	for line in line_container.get_children():
		line.queue_free()

func complete_shape(point:ConnectablePoint):
	completing_shape = true
	Main.instance.play_note(connected_points.size()+1)
	
	# Connect the current line to the point
	current_line.to = point.global_position
	
	# Remove all points & lines before the one that was connected to
	while !connected_points.is_empty() && connected_points[0] != point:
		connected_points[0].is_connected = false
		connected_lines[0].queue_free()
		connected_points.pop_front()
		connected_lines.pop_front()
	
	var tween = create_tween()
	
	# Hide all points
	for point_i in points:
		tween.parallel().tween_property(point_i, "modulate", Color.TRANSPARENT, 1)
	# Once hidden, each one should be reset
	tween.tween_callback(
		func ():
			for point_i in points:
				point_i.reset()
			# Also play the finished sound
			Main.instance.play_finish()
	)
	
	# Animate the lines
	for line in connected_lines:
		tween.parallel().tween_property(line, "width", line.width + 10, 3).set_trans(Tween.TRANS_SPRING)
		tween.parallel().tween_property(line, "color", Color.RED, 2).set_trans(Tween.TRANS_CUBIC)
	
	# Wait for all animations to complete, then delay and call back to done
	tween.tween_interval(2)
	
	# Hide lines and reveal points
	tween.tween_property($LineContainer, "self_modulate", Color.TRANSPARENT, 1)
	tween.tween_interval(0.1)
	for point_i in points:
		tween.parallel().tween_property(point_i, "modulate", Color.WHITE, 1)
	
	# Finally, reset
	tween.tween_callback(
		func ():
			clear()
	)
	# Wait a split second before revealing the lines again
	# Otherwise, the lines will flash back on screen quickly
	tween.tween_interval(0.05)
	tween.tween_callback(
		func ():
			$LineContainer.self_modulate = Color.WHITE
			completing_shape = false
	)

func _on_touch_input_primary_touch_event(event, longest_touched_point):
	
	if completing_shape:
		# We don't allow any interaction while completing the shape
		return
	
	if longest_touched_point == null:
		# Always clear when touch released
		clear()
		return
	
	# Check if each point is affected by touch
	for point in points:
		if point.is_pressed(longest_touched_point.position):
			try_connect_point(point)
			break
	
	# No longer want to update the line if completing the shape
	if completing_shape: return
	
	# Update the current line to follow the cursor
	if current_line != null:
		current_line.to = longest_touched_point.position

## Checks whether it's reasonable to connect a given point
func can_connect_point(point:ConnectablePoint) -> bool:
	# Don't connect last connected points as this would make a dot or line
	#  (i.e. the shape needs at least 3 points)
	if !connected_points.is_empty() && point == connected_points[-1]:
		return false
	if connected_points.size() >= 2 && point == connected_points[-2]:
		return false
	
	return  true

func try_connect_point(point:ConnectablePoint) -> bool:
	if !can_connect_point(point):
		return false
	
	connect_point(point)
	return true

func connect_point(point:ConnectablePoint):
	
	# If it's already connected, then we complete the shape
	if point.is_connected:
		complete_shape(point)
		return
	
	point.is_connected = true
	connected_points.push_back(point)
	if current_line != null:
		current_line.to = point.position
	current_line = add_line(point.position)
	connected_lines.push_back(current_line)
	Main.instance.play_note(connected_points.size())

func add_line(from:Vector2) -> CappedLine:
	var line = CappedLine.create(from, Vector2.ZERO, 30, Color.WHITE, true)
	line.owner = owner
	line_container.add_child(line)
	return line
