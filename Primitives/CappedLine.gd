@tool
extends DrawnLine
class_name CappedLine

@onready
var circles:Array[DrawnCircle] = [$DrawnCircleFrom, $DrawnCircleTo]

func _process(delta):
	super._process(delta)
	for circle in circles:
		circle.radius = width/2
		circle.color = color
	circles[0].position = from
	circles[1].position = to

static func create(from := Vector2.ZERO, to := Vector2.ZERO, width := -1.0,
					color := Color.WHITE, antialiased := false) -> CappedLine:
	var result:CappedLine = load("res://Primitives/capped_line.tscn").instantiate()
	result.color = color
	result.from = from
	result.to = to
	result.width = width
	result.antialiased = antialiased
	return result
