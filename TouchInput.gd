extends Node
class_name TouchInput

static var instance:TouchInput

func _enter_tree():
	if instance == null:
		instance = self
	elif instance != self:
		# Only one instance should be present
		queue_free()
func _exit_tree():
	if instance == self:
		instance = null

signal touch_event(event, longest_touched_point:TouchPoint, touch_points:Dictionary)

signal primary_touch_event(event, longest_touched_point:TouchPoint)

# All currently touched positions, by touch index
# Note that it may be that higher indexes are present, but lower indexes are not
static var touch_points := {}

# The longest touched point of all touched point
# This can be the sole point tracked for reduced point jumping
static var longest_touched_point:TouchPoint = null

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed: # Down.
			var touch_point := TouchPoint.new(event.index, event.position)
			touch_points[event.index] = touch_point
			if longest_touched_point == null:
				longest_touched_point = touch_point
				primary_touch_event.emit(event, longest_touched_point)
		else: # Up.
			touch_points.erase(event.index)
			# See if we need to recalculate the longest touched point
			if longest_touched_point.touch_index == event.index:
				if touch_points.is_empty():
					longest_touched_point = null
				else:
					longest_touched_point = touch_points.values().front()
					for value in touch_points.values():
						if value.time_touched_msec < longest_touched_point:
							longest_touched_point = value
				
				primary_touch_event.emit(event, longest_touched_point)
		
		touch_event.emit(event, longest_touched_point, touch_points)
		get_viewport().set_input_as_handled()
	
	elif event is InputEventScreenDrag:
		touch_points[event.index].position = event.position
		
		if longest_touched_point.touch_index == event.index:
			primary_touch_event.emit(event, longest_touched_point)
		
		touch_event.emit(event, longest_touched_point, touch_points)
		get_viewport().set_input_as_handled()
		

class TouchPoint:
	var position:Vector2
	var touch_index:int
	var time_touched_msec:int
	
	func _init(_touch_index:int, _position:Vector2):
		touch_index = _touch_index
		position = _position
		time_touched_msec = Time.get_ticks_msec()
