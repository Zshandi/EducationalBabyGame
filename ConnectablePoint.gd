@tool
extends Area2D
class_name ConnectablePoint

@onready
var anim_player:AnimationPlayerPlayOnce = $AnimationPlayer
@onready
var collision_circle:CircleShape2D = $CollisionShape2D.shape

var is_connected := false

var is_hover := false

func is_pressed(position:Vector2) -> bool:
	# Dev Note: Assumes the collision shape is just a circle
	var dist_sq = position.distance_squared_to(global_position)
	var radius_sq = collision_circle.radius * collision_circle.radius
	return dist_sq < radius_sq

func _ready():
	anim_player.play_once("idle")

func _process(delta):
	if is_connected:
		anim_player.play_once("click")
	elif is_hover:
		anim_player.play_once("hover")
	else:
		anim_player.play_once("idle")

func _on_mouse_entered():
	is_hover = true

func _on_mouse_exited():
	is_hover = false
