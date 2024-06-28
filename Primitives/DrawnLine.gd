@tool
extends Node2D
class_name DrawnLine

## Local position starting point of the line
@export
var from_point:Vector2 = Vector2.ZERO

## Local position ending point of the line
@export
var to_point:Vector2 = Vector2.ZERO

@export
var width:float = -1

@export
var color:Color = Color.WHITE

func _process(delta):
	queue_redraw()

func _draw():
	draw_line(from_point, to_point, color, width)

static func create(from_point := Vector2.ZERO, to_point := Vector2.ZERO, width := -1.0, color := Color.WHITE) -> DrawnLine:
	var result:DrawnLine = load("res://Primitives/drawn_line.tscn").instantiate()
	result.color = color
	result.from_point = from_point
	result.to_point = to_point
	result.width = width
	return result
