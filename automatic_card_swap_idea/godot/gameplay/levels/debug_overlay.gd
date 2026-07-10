extends CanvasLayer

@onready var reset_button: Button = %ResetButton


func _ready() -> void:
	reset_button.pressed.connect(_on_reset_button_pressed)

func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()
