class_name Card
extends Node2D

var face_up : bool = false :
	set(val):
		face_up = val
		front.visible = face_up
		back.visible = not face_up
		
var scale_tween : Tween = null
var mouseover_tween : Tween = null
var size : Vector2 : set = set_size 

@onready var visuals: Control = %Visuals
@onready var panel: PanelContainer = %Panel
@onready var shadow: Panel = %Shadow
@onready var front: MarginContainer = %Front
@onready var back: MarginContainer = %Back
@onready var press_detection: Button = %PressDetection

func _ready() -> void:
	face_up = face_up
	press_detection.pressed.connect(flip)
	press_detection.mouse_entered.connect(_on_press_detection_mouse_entered)
	press_detection.mouse_exited.connect(_on_press_detection_mouse_exited)

func flip() -> void:
	if animating_flip():
		return
	scale_tween = create_tween().set_trans(Tween.TRANS_SINE)
	scale_tween.set_ease(Tween.EASE_IN)
	scale_tween.tween_property(visuals, "scale:x", 0, 0.2)
	scale_tween.set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(visuals, "scale:x", 1, 0.2)
	await scale_tween.step_finished
	face_up = not face_up

func animating_flip() -> bool:
	return scale_tween and scale_tween.is_running()

func set_size(val) -> void:
	panel.size = val
	panel.position = -val * 0.5
	shadow.size = panel.size
	shadow.position = panel.position
	press_detection.size = panel.size
	press_detection.position = panel.position

func get_size() -> Vector2:
	return panel.size

func _on_press_detection_mouse_entered() -> void:
	if mouseover_tween: mouseover_tween.kill()
	mouseover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	mouseover_tween.tween_property(panel, "offset_transform_position:y", -40, 0.1)
	mouseover_tween.parallel().tween_property(panel, "offset_transform_scale", Vector2.ONE * 1.2, 0.1)

func _on_press_detection_mouse_exited() -> void:
	if mouseover_tween: mouseover_tween.kill()
	mouseover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	mouseover_tween.tween_property(panel, "offset_transform_position:y", 0, 0.1)
	mouseover_tween.parallel().tween_property(panel, "offset_transform_scale", Vector2.ONE, 0.1)
