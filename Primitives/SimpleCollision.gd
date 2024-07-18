## A lightweight Resource variation of the CollisionShape node,
##  for use in collisions with gdscript-generated shapes
extends Resource
class_name CollisionShapeRes

func _init(shape_base = null, transpos = null):
	if shape_base is Shape2D:
		shape = shape_base
	elif "shape" in shape_base && shape_base.shape is Shape2D:
		shape = shape_base.shape
		
		if "transform" in shape_base && shape_base.transform is Transform2D:
			transform = shape_base.transform
	
	if transpos is Transform2D:
		transform = transpos
	elif transpos is Vector2:
		position = transpos

@export
var shape:Shape2D

@export
var transform:Transform2D

var position:Vector2:
	get:
		return transform.get_origin()
	set(value):
		transform = transform.translated(value - transform.get_origin())

func collide(other) -> bool:
	var other_shape:Shape2D = null
	var other_transform:Transform2D
	
	if other is Shape2D:
		other_shape = other
	elif "shape" in other && other.shape is Shape2D && other.shape != null:
		other_shape = other.shape
		if "transform" in other && other.transform is Transform2D:
			other_transform = other.transform
	else:
		return false
	
	return shape.collide(transform, other_shape, other_transform)
