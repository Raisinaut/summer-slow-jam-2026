class_name Card
extends Node2D

var face_up : bool = false :
	set(val):
		face_up = val
		front.visible = face_up
		back.visible = not face_up
		
var scale_tween : Tween = null
var idle_tween : Tween = null
var size : Vector2 : set = set_size 

@onready var panel: PanelContainer = %Panel
@onready var front: MarginContainer = %Front
@onready var back: MarginContainer = %Back
@onready var press_detection: Button = %PressDetection

func _ready() -> void:
	face_up = face_up
	press_detection.pressed.connect(flip)

func flip() -> void:
	if animating_flip():
		return
	scale_tween = create_tween().set_trans(Tween.TRANS_SINE)
	scale_tween.set_ease(Tween.EASE_IN)
	scale_tween.tween_property(self, "scale:x", 0, 0.2)
	scale_tween.set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(self, "scale:x", 1, 0.2)
	await scale_tween.step_finished
	face_up = not face_up

func animating_flip() -> bool:
	return scale_tween and scale_tween.is_running()

func set_size(val) -> void:
	panel.size = val
	panel.position = -val * 0.5

func get_size() -> Vector2:
	return panel.size
