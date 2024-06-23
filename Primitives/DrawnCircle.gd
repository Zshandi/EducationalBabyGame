@tool
extends Node2D
class_name DrawnCircle

@export
var radius:float = 1

@export
var color:Color = Color.WHITE

func _process(delta):
	queue_redraw()

func _draw():
	draw_circle(Vector2.ZERO, radius, color)

static func create(radius:float = 1, color:Color = Color.WHITE) -> DrawnCircle:
	return load("res://Primitives/drawn_circle.tscn").instantiate()
