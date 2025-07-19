extends Node2D
## Audio manager node. Inteded to be globally loaded as a 2D Scene. Handles [method create_2d_audio_at_location()] and [method create_audio()] to handle the playback and culling of simultaneous sound effects.
##
## To properly use, define [enum SoundEffect.SOUND_EFFECT_TYPE] for each unique sound effect, create a Node2D scene for this AudioManager script add those SoundEffect resources to this globally loaded script's [member sound_effects], and setup your individual SoundEffect resources. Then, use [method create_2d_audio_at_location()] and [method create_audio()] to play those sound effects either at a specific location or globally.
## 
## See https://github.com/Aarimous/AudioManager for more information.
##
## @tutorial: https://www.youtube.com/watch?v=Egf2jgET3nQ

var sound_effect_dict: Dictionary = {} ## Loads all registered SoundEffects on ready as a reference.

@export var sound_effects: Array[SoundEffect] ## Stores all possible SoundEffects that can be played.
@export var bg_music_tracks: Array[AudioStream]

@onready var background_music = $BackgroundMusic
var min_volume = -30
var max_volume = 5
var sfx_volume

func _ready() -> void:
	background_music.stream = bg_music_tracks[0]
	change_bg_volume(Style.background_volume)
	background_music.play()
	change_sfx_volume(Style.sfx_volume)
	for sound_effect in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect

func change_bg_volume(volume_percent):
	if volume_percent == 0:
		background_music.volume_db = -80
	else:
		var bg_volume = min_volume + (35 * (volume_percent)/100.0)
		background_music.volume_db = bg_volume

func change_sfx_volume(volume_percent):
	if volume_percent == 0:
		sfx_volume = -80
	else:
		var volume = min_volume + (35 * (volume_percent)/100.0)
		sfx_volume = volume

## Creates a sound effect if the limit has not been reached. Pass [param type] for the SoundEffect to be queued.
func create_audio(type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(new_audio)
			new_audio.stream = sound_effect.sound_effect
			new_audio.volume_db = sfx_volume
			new_audio.pitch_scale = sound_effect.pitch_scale
			new_audio.pitch_scale += Global.random.randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness )
			new_audio.finished.connect(sound_effect.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()
	else:
		push_error("Audio Manager failed to find setting for type ", type)
