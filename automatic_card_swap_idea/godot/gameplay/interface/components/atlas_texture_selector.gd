@tool
class_name AtlasTextureSelector
extends TextureRect

@onready var atlas_texture : AtlasTexture = texture

@export var index : int = 0 : set = set_index
@export var cols : int = 1
@export var rows : int = 1


func _ready() -> void:
	print(index)

func set_index(val) -> void:
	val = clamp(val, 0, max_index())
	index = val
	var col = index % cols
	var row = (index - col) % rows
	var cell_coords := Vector2(col, row)
	if not is_node_ready():
		await ready
	atlas_texture.region.position = get_cell_size() * cell_coords

func get_cell_size() -> Vector2:
	return atlas_texture.region.size

func max_index() -> int:
	return cols * rows - 1
