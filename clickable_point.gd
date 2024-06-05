@tool
extends Node2D
class_name ClickablePoint

@export
var clickable_radius:float = 45

## Whether the cursor is over the point (regardless if pressed or not)
var is_cursor_over:bool = false

## Set to true when the point is pressed on, then false once released
## This will still be true if dragged off of the point
var is_pressed:bool = false

## Set to true if anywhere on the screen is pressed (over or off of the point)
var is_anywhere_pressed:bool = false

## Set to current cursor position
var cursor_position:Vector2

func process_input_event(event:InputEvent, is_on_point:bool):
	var is_left_click = event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT
	var is_touch = event is InputEventScreenTouch
	
	var is_drag = event is InputEventScreenDrag
	var is_mouse_motion = event is InputEventMouseMotion
	
	# For simple press & release, touch and mouse are identical
	if is_touch || is_left_click:
		if event.is_released():
			is_anywhere_pressed = false
			is_pressed = false
		elif event.is_pressed():
			is_anywhere_pressed = true
			if is_on_point:
				is_pressed = true
	
	# Process "hover" for touch
	# (finger on screen while over the point)
	if is_touch && is_on_point:
		if event.is_released():
			is_cursor_over = false
		elif event.is_pressed():
			is_cursor_over = true
	
	# Process "hover" for touch or mouse
	if is_drag || is_mouse_motion:
		is_cursor_over = is_on_point
	
	# Update cursor position
	if is_mouse_motion || is_drag || is_touch:
		cursor_position = event.position

func _unhandled_input(event):
	var is_on_point := false
	if "position" in event:
		is_on_point = event.position.distance_to(global_position) < clickable_radius
	process_input_event(event, is_on_point)
