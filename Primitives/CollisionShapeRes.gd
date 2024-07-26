## A lightweight Resource variation of the CollisionShape node,
##  for use in collisions with gdscript-generated shapes
extends Resource
class_name CollisionShapeRes

func _init(shape_base = null, transpos = null):
	if shape_base is Shape2D:
		shape = shape_base
	elif shape_base != null && "shape" in shape_base && shape_base.shape is Shape2D:
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
	other = CollisionShapeRes.new(other)
	
	if other.shape == null:
		assert(false, "collide: invalid argument")
		return false
	
	return shape.collide(transform, other.shape, other.transform)

func collide_and_get_contacts(other) -> PackedVector2Array:
	other = CollisionShapeRes.new(other)
	
	if other.shape == null:
		assert(false, "collide_and_get_contacts: invalid argument")
		return []
	var collision = shape.collide_and_get_contacts(transform, other.shape, other.transform)
	#if !collision.is_empty():
		#print_debug("transform = ", transform, ", other.shape = ", other.shape, ", other.transform = ", other.transform)
	return collision
