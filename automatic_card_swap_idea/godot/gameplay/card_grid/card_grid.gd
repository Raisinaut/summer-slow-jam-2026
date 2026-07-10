@tool
class_name CardGrid
extends ReferenceRect

@export_range(0, 1, 1, "or_greater") var columns : int = 4 :
	set(val): columns = val; check_grid_validity()
@export_range(0, 1, 1, "or_greater") var rows : int = 3 :
	set(val): rows = val; check_grid_validity()
@export var card_scene : PackedScene
@export var spacing : int = 20
@export var variant_count : int = 4 # must be less than half of the grid size

var data_variants : Array[CardData] = []
var deck : Array[CardData] = []
var card_coords : Dictionary[Vector2, Card] = {}
var first_card : Card = null
var second_card : Card = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	generate_data_variants()
	generate_deck()
	populate()

## SETUP -----------------------------------------------------------------------
func generate_data_variants() -> void:
	for i in variant_count:
		var data = CardData.new()
		data.value = i
		data_variants.append(data)

func generate_deck() -> void:
	check_grid_validity()
	var pair_count : int = round(grid_item_max() / 2.0)
	var data_variants_copy = data_variants.duplicate(true)
	for i in pair_count:
		if data_variants_copy.is_empty():
			data_variants_copy = data_variants.duplicate(true)
			print("refresh variants copy")
		data_variants_copy.shuffle()
		print("select variant")
		var data = data_variants_copy.pop_back()
		print(data.value)
		# create a pair
		deck.append(data)
		deck.append(data)


func populate() -> void:
	var card_spacing = Vector2.ONE * spacing
	var card_area : Vector2 = size / Vector2(columns, rows)
	var max_card_size = card_area - card_spacing
	var card_center_offset = card_area * 0.5
	for x in columns:
		for y in rows:
			var c = create_card(draw_shuffled_card_data())
			var coords = Vector2(x, y)
			card_coords[coords] = c
			c.position = card_area * coords + card_center_offset
			c.ready.connect(maximize_card_size.bind(c, max_card_size))
			c.started_flip.connect(_on_card_started_flip.bind(c))

## Returns CardData from a shuffled deck and removes it from the pool
## If drawing is attempted on a depleted deck, the deck is refreshed
func draw_shuffled_card_data() -> CardData:
	deck.shuffle()
	return deck.pop_back()

func create_card(data : CardData) -> Card:
	var card = card_scene.instantiate()
	call_deferred("add_child", card)
	card.data = data
	return card

func maximize_card_size(card : Card, max_size : Vector2) -> void:
	card.set_size(fit_vector_proportinally(card.get_size(), max_size))

func fit_vector_proportinally(original: Vector2, target: Vector2) -> Vector2:
	var change_percent : float = 0
	var x_change_percent = target.x / original.x
	var y_change_percent = target.y / original.y
	if x_change_percent < y_change_percent:
		change_percent = x_change_percent
	else:
		change_percent = y_change_percent
	return original * change_percent



# MATCH HANDLING ---------------------------------------------------------------
func attempt_match(card1 : Card, card2 : Card) -> void:
	for i in get_children():
		i.set_interaction_disabled(true)
	
	if card1.data.value == card2.data.value:
		await get_tree().create_timer(0.5).timeout
		correct_match()
		#await get_tree().create_timer(1.0).timeout
	else:
		await get_tree().create_timer(0.8).timeout
		incorrect_match()
	
	for i in get_children():
		i.set_interaction_disabled(false)

func correct_match() -> void:
	# animate
	first_card.flash().finished.connect(first_card.queue_free)
	second_card.flash().finished.connect(second_card.queue_free)
	## delete
	#first_card.queue_free()
	#second_card.queue_free()
	# reset
	first_card = null
	second_card = null

func incorrect_match() -> void:
	# reset cards
	var _first_card = first_card
	var _second_card = second_card
	first_card = null
	second_card = null
	# animate
	#first_card.shake()
	#await second_card.shake().finished
	await _first_card.flip()
	await _second_card.flip()

func _on_card_started_flip(card: Card) -> void:
	# only consider cards that are flipping toward face up,
	# not cards that are starting to flip while already facing up
	if card.face_up: return
	if !first_card:
		first_card = card
	elif !second_card:
		second_card = card
		attempt_match(first_card, second_card)


# CHECKS -----------------------------------------------------------------------
func check_grid_validity() -> void:
	if grid_item_max() % 2 != 0:
		push_warning("Grid should have an even number of items.")

func grid_item_max() -> int:
	return columns * rows
