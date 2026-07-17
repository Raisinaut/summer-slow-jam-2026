extends Node2D

@onready var card_grid: CardGrid = %CardGrid
@onready var camera: = %Camera
@onready var opponent: Opponent = %Opponent
@onready var interface: = %Interface

@export var is_user_turn : bool = true : set = set_is_user_turn

func _ready() -> void:
	card_grid.lockout_changed.connect(_on_card_grid_lockout_changed)
	card_grid.attempted_match.connect(_on_card_grid_attempted_match)


# SIGNALS ----------------------------------------------------------------------
func _on_card_grid_lockout_changed(state : bool) -> void:
		camera.target_zoom = 1.05 if state else 1.0

func _on_card_grid_attempted_match(_correct : bool) -> void:
	is_user_turn = not is_user_turn


# SETTERS ----------------------------------------------------------------------
func set_is_user_turn(val) -> void:
	is_user_turn = val
	if not is_user_turn:
		opponent.play()
	interface.field_input_disabled = not is_user_turn
