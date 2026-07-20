class_name Opponent
extends Node

@export var display_name : String
@export var portrait_texture : Texture
@export var card_grid : CardGrid
@export var max_memory_size : int = 3
@export var memory_turn_lifetime: int = 2

var can_play : bool = false
var card_memory : Dictionary[Card, int] = {}
var selection : Array[Card] = []
var turns_till_forget : int = memory_turn_lifetime : set = set_turns_till_forget

func _ready() -> void:
	card_grid.card_flipped.connect(_on_card_grid_card_flipped)

## Plays any found match in order of discovery [br]
## or attempts to make a spontaneous match with [br]
## an already known card and an unknown card.
func play() -> void:
	#print("Opponent turn started.")
	if card_grid.active_cards.is_empty():
		#print("-No cards to choose from")
		return
	# Select Cards
	selection = get_known_match()
	if selection.is_empty():
		print("-No match known in memory.")
		# Select an unknown card
		selection.append(select_unknown_card())
		# Check if it matches one in memory
		var memory_match : Card = find_memory_match(selection[0])
		if memory_match:
			print("-Unknown card matches one in memory.")
			selection.append(memory_match)
		else:
			print("-Unknown card doesn't match any in memory.")
			#print("--Selecting another unknown card.")
			var c : Card = select_unknown_card()
			if c: selection.append(c)
	else:
		print("-Match is known in memory.")
	if selection:
		for i : Card in selection:
			await i.flip()
	
	turns_till_forget -= 1
	print()

func get_known_match() -> Array[Card]:
	var cards = get_cards_by_least_recent()
	for i in cards:
		for j in cards:
			if i != j:
				if i.data.front == j.data.front:
					return [i, j]
	return []

func get_cards_by_least_recent() -> Array[Card]:
	var cards = card_memory.keys()
	cards.sort_custom(func(a, b): return card_memory[a] < card_memory[b])
	return cards

func select_unknown_card() -> Card:
	# Remove known cards from selection pool
	var active_cards = card_grid.active_cards.duplicate(true)
	for card in card_memory.keys():
		active_cards.erase(card)
	for card in selection:
		active_cards.erase(card)
	if active_cards.size() == 0:
		push_error("Could not select unkown card. All active cards are known.")
		return null
	# select randomly from the remaining cards
	active_cards.shuffle()
	return active_cards[0]

func find_memory_match(card : Card) -> Card:
	if card == null: return null
	for i : Card in card_memory.keys():
		if i.data.front == card.data.front:
			return i
	return null

func set_turns_till_forget(val) -> void:
	if val < 0:
		forget_least_recent_card()
		val = memory_turn_lifetime
	turns_till_forget = val

func _on_card_grid_card_flipped(card : Card) -> void:
	# add card to memory
	if not card_memory.has(card):
		card_memory[card] = memory_turn_lifetime
		# Connect matched signal
		if not card.just_matched.is_connected(_on_card_just_matched):
			card.just_matched.connect(_on_card_just_matched.bind(card))
		# Forget cards if beyond memory capacity
		if card_memory.size() > max_memory_size:
			forget_least_recent_card()

func forget_least_recent_card() -> void:
	print("forget card")
	card_memory.erase(get_cards_by_least_recent()[0])

# Forget about cards that have matched
func _on_card_just_matched(card : Card) -> void:
	card_memory.erase(card)
