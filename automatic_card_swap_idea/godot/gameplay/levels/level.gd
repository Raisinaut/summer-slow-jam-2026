extends Node2D

@onready var card_grid: CardGrid = %CardGrid

var swap_interval : int = 2
var swap_attempts : int = 0

func _ready() -> void:
	card_grid.attempted_match.connect(_on_card_grid_attempted_match)

func _on_card_grid_attempted_match(_correct : bool) -> void:
	swap_attempts += 1
	if swap_attempts >= swap_interval:
		swap_attempts = 0
		card_grid.swap_random_card_positions()
