@tool
extends Area2D
class_name ConnectablePoint

var is_connected := false

var is_hover := false

func is_pressed(position:Vector2) -> bool:
	# Dev Note: Assumes the collision shape is just a circle
	var dist_sq = position.distance_squared_to($CollisionShape2D.global_position)
	var radius_sq = $CollisionShape2D.shape.radius * $CollisionShape2D.shape.radius
	return dist_sq < radius_sq

func _ready():
	$AnimationPlayer.play_once("idle")

func _process(delta):
	if is_connected:
		$AnimationPlayer.play_once("click")
	elif is_hover:
		$AnimationPlayer.play_once("hover")
	else:
		$AnimationPlayer.play_once("idle")

func _on_mouse_entered():
	is_hover = true

func _on_mouse_exited():
	is_hover = false
