@tool
extends AnimationPlayer
class_name AnimationPlayerPlayOnce

var last_played:StringName = ""

func _ready():
	animation_started.connect(
		func(anim_name: StringName):
			last_played = anim_name
	)

func play_once(name: StringName = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false):
	if last_played != name:
		play(name, custom_blend, custom_speed, from_end)
		last_played = name

