class_name Opponent
extends Node

@export var display_name : String
@export var portrait_texture : Texture
@export var card_grid : CardGrid

var can_play : bool = false
var card_memory : Array[Card] = []
var memory_turn_lifetime : int = 2

func _ready() -> void:
	card_grid.card_flipped.connect(_on_card_grid_card_flipped)

## Plays any found match in order of discovery [br]
## or attempts to make a spontaneous match with [br]
## an already known card and an unknown card.
func play() -> void:
	print("Opponent turn started.")
	# Attempt to find match
	var selection : Array[Card] = get_known_match()
	if selection.is_empty():
		print("No match known in memory.")
		selection.append(select_unknown_card())
		var memory_match : Card = find_memory_match(selection[0])
		if memory_match:
			print("Unknown card matches one in memory.")
			selection.append(memory_match)
		else:
			print("Unknown card doesn't match any in memory. Checking another.")
			var c = select_unknown_card()
			if c:
				selection.append(c)
	else:
		print("Match is known in memory.")
	if selection:
		print("Flipping selected cards")
		for i : Card in selection:
			await i.flip()
	else:
		print("No cards to select")
	print()

func get_known_match() -> Array[Card]:
	for i in card_memory:
		for j in card_memory:
			if i != j:
				if i.data.front == j.data.front:
					return [i, j]
	return []

func select_unknown_card() -> Card:
	# Remove known cards from selection pool
	var active_cards = card_grid.active_cards.duplicate(true)
	for card in card_memory:
		active_cards.erase(card)
	if active_cards.size() == 0:
		push_error("Could not select unkown card. All active cards are known.")
		return null
	active_cards.shuffle()
	return active_cards[0]

func find_memory_match(card : Card) -> Card:
	if card == null: return null
	for i : Card in card_memory:
		if i.data.front == card.data.front:
			return i
	return null

func _on_card_grid_card_flipped(card : Card) -> void:
	# add card to memory
	if not card_memory.has(card):
		card_memory.append(card)
		# connect match signal to disregard in future consideration
		card.just_matched.connect(card_memory.erase.bind(card))
