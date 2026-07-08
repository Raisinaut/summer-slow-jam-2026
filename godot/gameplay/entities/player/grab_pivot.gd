extends Node2D

@onready var detection_area : DetectionArea = %DetectionArea
@onready var grab_origin: Node2D = %GrabOrigin

var held_node : Grabbable = null

func attempt_grab() -> void:
	var detected_node = detection_area.get_nearest_contained_node()
	if detected_node:
		# TODO: add SFX
		held_node = detected_node

func attempt_drop() -> void:
	if held_node:
		# TODO: add SFX
		held_node = null

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	if held_node:
		held_node.global_position = grab_origin.global_position

func _input(event: InputEvent) -> void:
	if event.is_action("lmb"):
		if event.is_pressed() and !event.is_echo():
			if held_node: attempt_drop()
			else:         attempt_grab()
