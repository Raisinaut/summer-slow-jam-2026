class_name Opponent
extends Node

@export var display_name : String
@export var portrait_texture : Texture
@export var card_grid : CardGrid

var can_play : bool = false
var card_memory : Array[Card] = []

func play() -> void:
	var random_selection = card_grid.get_random_cards(2)
	for i : Card in random_selection:
		await i.flip()
