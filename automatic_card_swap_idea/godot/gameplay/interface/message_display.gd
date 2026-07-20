extends Control

@onready var message_label: Label = %MessageLabel

var fade_time: float = 0.3
var pause_time: float = 1.0
var fade_tween : Tween = null

func _ready() -> void:
	modulate.a = 0
	message_label.modulate.a = 0
	animate_fade()

func display_message(text : String, force_uppercase := false) -> Tween:
	if force_uppercase:
		text = text.to_upper()
	message_label.text = text
	return animate_fade()

func animate_fade() -> Tween:
	visible = true
	if fade_tween: fade_tween.kill()
	fade_tween = create_tween()
	# show main control
	fade_tween.tween_property(self, "modulate:a", 1.0, fade_time)
	# show text
	fade_tween.tween_property(message_label, "modulate:a", 1.0, fade_time)
	fade_tween.tween_interval(pause_time)
	fade_tween.tween_property(message_label, "modulate:a", 0.0, fade_time)
	fade_tween.tween_property(self, "modulate:a", 0.0, fade_time)
	fade_tween.finished.connect(_on_fade_tween_finished)
	return fade_tween

func _on_fade_tween_finished() -> void:
	visible = false
