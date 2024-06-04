@tool
extends Area2D
class_name ClickablePoint

static var current_point:ClickablePoint

var next_points:Array[ClickablePoint]

var is_first_point:bool = false

@export
var clickable_radius:float = 45

@export
var radius:float = 25:
	get:
		return radius
	set(value):
		radius = value
		if shape != null:
			shape.radius = value

@export
var radiusHover:float = 30
@export
var radiusPressed:float = 45

@export
var color:Color = Color.WHITE

@export
var line_width:float = 25

@onready
var shape:CircleShape2D = $PointCollision.shape

var is_hover:bool = false

var is_pressed:bool = false

var is_any_pressed:bool = false

var cursor_position:Vector2

func _ready():
	shape.radius = radius

func _process(delta):
	
	if !is_any_pressed:
		current_point = null
		next_points = []
	
	if is_hover && (is_pressed || is_any_pressed):
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
	var finalRadius := radius
	
	if current_point == self || !next_points.is_empty():
		finalRadius = radiusPressed
	elif is_hover:
		finalRadius = radiusHover
	
	if current_point == self:
		draw_line(Vector2.ZERO, to_local(cursor_position), color, line_width)
	
	for point in next_points:
		draw_line(Vector2.ZERO, to_local(point.global_position), color, line_width)
	
	draw_circle(Vector2.ZERO, finalRadius, color)

func process_input_event(event:InputEvent, is_on_point:bool):
	var is_left_click = event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT
	var is_touch = event is InputEventScreenTouch
	
	var is_drag = event is InputEventScreenDrag
	var is_mouse_motion = event is InputEventMouseMotion
	
	# For simple press & release, touch and mouse are identical
	if is_touch || is_left_click:
		if event.is_released():
			is_any_pressed = false
			is_pressed = false
		elif event.is_pressed():
			is_any_pressed = true
			if is_on_point:
				is_pressed = true
	
	# Process "hover" for touch
	# (finger on screen while over the point)
	if is_touch && is_on_point:
		if event.is_released():
			is_hover = false
		elif event.is_pressed():
			is_hover = true
	
	if is_drag:
		is_hover = is_on_point
	
	# Update cursor position
	if is_mouse_motion || is_drag || is_touch:
		cursor_position = event.position

func _input(event):
	var is_on_point := false
	if "position" in event:
		is_on_point = event.position.distance_to(global_position) < clickable_radius
	process_input_event(event, is_on_point)

func _on_mouse_entered():
	is_hover = true

func _on_mouse_exited():
	is_hover = false
