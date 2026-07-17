extends Node2D

@onready var card_grid: CardGrid = %CardGrid
@onready var camera: = %Camera


func _ready() -> void:
	card_grid.lockout_changed.connect(_on_card_grid_lockout_changed)

func _on_card_grid_lockout_changed(state : bool) -> void:
		camera.target_zoom = 1.05 if state else 1.0
