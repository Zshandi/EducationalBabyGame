@tool
extends Node2D
class_name DrawnLine

## Local position starting point of the line
@export
var from:Vector2 = Vector2.ZERO

## Local position ending point of the line
@export
var to:Vector2 = Vector2.ZERO

@export
var width:float = -1

@export
var color:Color = Color.WHITE

@export
var antialiased:bool = false

func _process(delta):
	queue_redraw()

func _draw():
	draw_line(from, to, color, width, antialiased)

static func create(from := Vector2.ZERO, to := Vector2.ZERO, width := -1.0,
					color := Color.WHITE, antialiased := false) -> DrawnLine:
	var result:DrawnLine = load("res://Primitives/drawn_line.tscn").instantiate()
	result.color = color
	result.from = from
	result.to = to
	result.width = width
	result.antialiased = antialiased
	return result
