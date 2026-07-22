extends Node

@export var main_music : AudioStream
@export var match_sound : AudioStream

@onready var current_player: AudioStreamPlayer = %CurrentPlayer

var match_effect_timer : SceneTreeTimer
var match_sfx_cooldown : float = 0.1

func _ready() -> void:
	current_player.stream = main_music
	current_player.play()

func play_match_effect() -> void:
	if match_cooldown():
		return
	match_effect_timer = get_tree().create_timer(match_sfx_cooldown)
	%MatchSFX.play_random()

func match_cooldown() -> bool:
	return match_effect_timer and match_effect_timer.time_left
