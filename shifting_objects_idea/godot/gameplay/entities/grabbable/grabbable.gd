class_name Grabbable
extends CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _physics_process(_delta: float) -> void:
	move_and_slide()

func set_collision_disabled(state : bool) -> void:
	collision_shape_2d.call_deferred("set_disabled", state)
