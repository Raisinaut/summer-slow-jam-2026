extends Control

@onready var opponent_info: PlayerInfo = %OpponentInfo
@onready var user_info: PlayerInfo = %UserInfo
@onready var field_area: Control = %FieldArea

var field_input_disabled : bool = false : set = set_field_input_disabled

func _ready() -> void:
	GameManager.score_changed.connect(_on_game_manager_score_changed)

func set_field_input_disabled(state) -> void:
	field_input_disabled = state
	if field_input_disabled:
		field_area.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		field_area.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_game_manager_score_changed(id : String, value : int) -> void:
	pass
