extends Node2D
class_name Main

static var twelfth_root := 1.05946309436

static var instance:Main

func _init():
	instance = self

func _ready():
	pass
	#for i in range(0, 25):
		#play_note(i)
		#await $AudioStreamPlayer.finished

func play_note(step:int):
	var pitch_semitone = step
	var pitch_scale = get_pitch_scale_for(pitch_semitone)
	
	adjust_pitch_scale($AudioStreamPlayer, pitch_scale)
	$AudioStreamPlayer.play()


## Adjust pitch by total [param pitch_scale] of both the given [param stream_player] and
##  audio bus [param effect], with the given [param stream_to_effect_ratio].
## 
## If [param stream_to_effect_ratio] is 0, it will be only adjusted on the [param stream_player],
##  if it's 1, only on the bus [param effect], and anything in-between is a mix of both.
## 
## 
## 
## The purpose of this method is to provide a balance between
##  scaling pitch by speeding it up (via stream) vs not (via bus effect).
## Speeding it up has the downside of shortening its duration, while by
##  not shortening it, distortion is introduced after pitching by more than one octave.
## So, by balancing between them, we can have a wider range that doesn't
##  sound strange.
func adjust_pitch_scale(stream_player:AudioStreamPlayer, pitch_scale:float,
	stream_to_effect_ratio:float = 0.5, effect:AudioEffectPitchShift = null):
	
	effect = _get_bus_effect(stream_player, effect)
	
	# Do some math to find each pitch scale
	# Find octave shift with base 2 log
	var octaves = log(pitch_scale) / log(2)
	# Divide the octaves between the scales based on ratio
	var stream_octaves = octaves * stream_to_effect_ratio
	var effect_octaves = octaves - stream_octaves
	# Convert octaves back to pitch scale
	var stream_pitch = pow(2, stream_octaves)
	var effect_pitch = pow(2, effect_octaves)
	
	# Adjust the scale
	stream_player.pitch_scale = stream_pitch
	effect.pitch_scale = effect_pitch

func _get_bus_effect(stream_player:AudioStreamPlayer, effect:AudioEffectPitchShift = null):
	var bus_idx := AudioServer.get_bus_index(stream_player.bus)
	# Null effect means use first pitch shift effect on stream player's bus,
	#  or create one if we can't find it
	if effect == null:
		for effect_idx in AudioServer.get_bus_effect_count(bus_idx):
			var effect_inst = AudioServer.get_bus_effect(bus_idx, effect_idx)
			if effect_inst is AudioEffectPitchShift:
				effect = effect_inst
				break
		if effect == null:
			effect = AudioEffectPitchShift.new()
			AudioServer.add_bus_effect(bus_idx, effect)
	
	return effect

func get_pitch_scale_for(semitones:float):
	print_debug("\n semitones: ", semitones)
	# Each octave doubles (or halves) the pitch
	# There are 12 semitones in an octave,
	#  so each semitone multiplies by 12th root of 2
	var pitch_scale:float = pow(twelfth_root, semitones)
	print_debug("\n pitch_scale: ", pitch_scale)
	
	return pitch_scale
