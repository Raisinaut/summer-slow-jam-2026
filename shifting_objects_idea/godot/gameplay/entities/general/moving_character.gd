class_name MovingCharacter
extends CharacterBody2D

enum STATES {
	MOVE,
}

var state := STATES.MOVE : set = set_state
var move_direction := Vector2.ZERO
var last_velocity := Vector2.ZERO
var target_velocity := Vector2.ZERO
var actual_velocity : Vector2
var last_position : Vector2


@export_range(10, 100, 1.0, "or_greater") var base_speed : float = 500
@export_range(10, 100, 1.0, "or_greater") var accel : float = 3500
@export_range(10, 100, 1.0, "or_greater") var decel : float = 2000

@onready var sprite = $Sprite2D
@onready var sprite_animator = $SpriteAnimator


func _ready() -> void:
	state = STATES.MOVE

func _physics_process(delta: float) -> void:
	match(state):
		STATES.MOVE:
			update_velocity(delta)
			move_and_slide()
			#update_movement_animation()
	actual_velocity = global_position - last_position
	last_position = global_position


# STATE LOGIC ----------------------------------------------------------
func update_velocity(delta : float) -> void:
	var rate_of_change = decel
	target_velocity = Vector2.ZERO
	if move_direction:
		rate_of_change = accel
		target_velocity = base_speed * move_direction
		last_velocity = velocity
	velocity = velocity.move_toward(target_velocity, delta * rate_of_change)

func update_movement_animation() -> void:
	if move_direction != Vector2.ZERO:
		play_animation_in_facing_direction("walk", last_velocity)
		sync_sprite_flip(velocity)
	else:
		if velocity == Vector2.ZERO:
			play_animation_in_facing_direction("idle", last_velocity)


# STATE CHANGE LOGIC -----------------------------------------------------------
func set_state(value : STATES):
	#sprite_animator.speed_scale = 1.0
	state = value


# SIGNALS ----------------------------------------------------------------------



# UPDATE FUNCTIONS -------------------------------------------------------------
func sync_sprite_flip(vector : Vector2) -> void:
	if vector.x > 0:
		sprite.flip_h = true
	elif vector.x < 0:
		sprite.flip_h = false


func play_animation_in_facing_direction(anim_prefix : String, vector : Vector2):
	var dir : String = get_vector_as_string(vector)
	sprite_animator.play(anim_prefix + "_" + dir)

## Returns a string matching the vector's direction. [br]
## Combine_horizontal merges "left" and "right" into "side"
func get_vector_as_string(vector : Vector2, combine_horizontal := true) -> String:
	var direction : String = ""
	if abs(vector.x) > abs(vector.y):
		if combine_horizontal:
			direction = "side"
		
		elif vector.x >= 0:
			direction = "right"
		else:
			direction = "left"
	else:
		if vector.y >= 0:
			direction = "down"
		else:
			direction = "up"
	return direction
