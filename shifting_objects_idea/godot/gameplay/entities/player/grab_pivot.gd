extends Node2D

@onready var detection_area : DetectionArea = %DetectionArea
@onready var grab_origin: Node2D = %GrabOrigin

var held_node : Grabbable = null
var rotation_speed : float = 10

func attempt_grab() -> void:
	var detected_node = detection_area.get_nearest_contained_body()
	if detected_node:
		# TODO: add SFX
		held_node = detected_node
		held_node.set_collision_disabled(true)

func attempt_drop() -> void:
	if held_node:
		# TODO: add SFX
		held_node.set_collision_disabled(false)
		held_node = null

func _process(delta: float) -> void:
	var mouse_dir = global_position.direction_to(get_global_mouse_position())
	rotation = lerp_angle(rotation, mouse_dir.angle(), delta * rotation_speed)
	
	if held_node:
		held_node.global_position = grab_origin.global_position

func _input(event: InputEvent) -> void:
	if event.is_action("lmb"):
		if event.is_pressed() and !event.is_echo():
			if held_node: attempt_drop()
			else:         attempt_grab()
