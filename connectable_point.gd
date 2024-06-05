
extends ClickablePoint
class_name ConnectablePoint

static var current_point:ConnectablePoint

var next_points:Array[ConnectablePoint]

var is_first_point:bool = false

@export
var radius:float = 25
@export
var radius_hover:float = 30
@export
var radius_pressed:float = 45

@export
var color:Color = Color.WHITE

@export
var line_width:float = 25


func _process(delta):
	
	if !is_anywhere_pressed:
		current_point = null
		next_points = []
	
	if is_cursor_over && (is_pressed || is_anywhere_pressed):
		if current_point == null:
			current_point = self
			Input.vibrate_handheld()
		elif current_point != self:
			# Ensure we don't have double-lines
			if !current_point.next_points.has(self) && !next_points.has(current_point):
				current_point.next_points.push_back(self)
				current_point = self
				Input.vibrate_handheld()
	
	queue_redraw()

func _draw():
	var final_radius := radius
	
	if current_point == self || !next_points.is_empty():
		final_radius = radius_pressed
	elif is_cursor_over:
		final_radius = radius_hover
	
	if current_point == self:
		draw_line(Vector2.ZERO, to_local(cursor_position), color, line_width)
	
	for point in next_points:
		draw_line(Vector2.ZERO, to_local(point.global_position), color, line_width)
	
	draw_circle(Vector2.ZERO, final_radius, color)
