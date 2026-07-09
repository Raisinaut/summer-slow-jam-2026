extends ReferenceRect

@export var columns : int = 4
@export var rows : int = 3
@export var card_scene : PackedScene
@export var spacing : int = 20

var card_coords : Dictionary[Vector2, Card] = {}

func _ready() -> void:
	populate()

func populate() -> void:
	var card_spacing = Vector2.ONE * spacing
	var card_area : Vector2 = size / Vector2(columns, rows)
	var max_card_size = card_area - card_spacing
	var card_center_offset = card_area * 0.5
	for x in columns:
		for y in rows:
			var c = create_card("put data here")
			var coords = Vector2(x, y)
			card_coords[coords] = c
			c.position = card_area * coords + card_center_offset
			c.ready.connect(maximize_card_size.bind(c, max_card_size))

func create_card(_data) -> Card:
	var card = card_scene.instantiate()
	call_deferred("add_child", card)
	return card

func maximize_card_size(card : Card, max_size : Vector2) -> void:
	card.set_size(fit_vector_proportinally(card.get_size(), max_size))

func get_largest_vector_dimension(vec : Vector2) -> float:
	if vec.x > vec.y:
		return vec.x
	else:
		return vec.y

func fit_vector_proportinally(original: Vector2, target: Vector2) -> Vector2:
	var change_percent : float = 0
	var x_change_percent = target.x / original.x
	var y_change_percent = target.y / original.y
	if x_change_percent < y_change_percent:
		change_percent = x_change_percent
	else:
		change_percent = y_change_percent
	return original * change_percent
