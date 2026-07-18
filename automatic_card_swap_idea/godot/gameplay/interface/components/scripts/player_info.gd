class_name PlayerInfo
extends PanelContainer

var portrait_texture : Texture = null : set = set_portrait_texture
var name_text : String = "" : set = set_name_text

@onready var portrait: TextureRect = %Portrait
@onready var name_label: Label = %NameLabel
@onready var portrait_back: TextureRect = %PortraitBack

func _ready() -> void:
	portrait_back.visible = true # hidden in editor to avoid rendering shader

func set_portrait_texture(val) -> void:
	portrait_texture = val
	portrait.texture = val

func set_name_text(val) -> void:
	name_text = val
	name_label.text = val
