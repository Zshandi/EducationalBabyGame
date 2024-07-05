extends Node2D
class_name Main

static var twelfth_root := 1.05946309436

static var instance:Main

func _init():
	instance = self

func play_note(step:int):
	var pitch_semitone = step - 12
	var pitch_scale = get_pitch_scale_for(pitch_semitone)
	adjust_pitch_scale(pitch_scale, 0.4, $AudioStreamPlayer)
	$AudioStreamPlayer.play()

func adjust_pitch_scale(pitch_scale:float, stream_to_effect_ratio:float,
	stream_player:AudioStreamPlayer, effect:AudioEffectPitchShift = null):
	
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
	
	# Do some math to find each pitch scale
	var stream_pitch = sqrt(pitch_scale / stream_to_effect_ratio)
	var effect_pitch = pitch_scale / stream_pitch
	
	# Adjust the scale
	stream_player.pitch_scale = stream_pitch
	effect.pitch_scale = effect_pitch

func get_pitch_scale_for(semitones:int):
	# Each octave doubles (or halves) the pitch
	# There are 12 semitones in an octave,
	#  so each semitone multiplies by 12th root of 2
	var pitch_scale:float = pow(twelfth_root, semitones)
	
	return pitch_scale
