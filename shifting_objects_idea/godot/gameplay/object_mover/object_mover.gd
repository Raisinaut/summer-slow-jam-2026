extends Node2D

var can_move : bool = false : set = set_can_move
var move_speed : float = 10
var node_directions : Dictionary[Node2D, Vector2] = {}
var direction_change_timer : SceneTreeTimer = null
var direction_change_interval : float = 1

func _ready() -> void:
	change_directions()
	start_direction_change_timer()

#func _process(delta: float) -> void:
	#for i in node_directions:
		#var movement = node_directions[i] * move_speed * delta
		#i.global_position += movement

func change_directions() -> void:
	for i : Node2D in get_children():
		var ang = randf_range(0, 2 * PI)
		var dir = Vector2.from_angle(ang)
		node_directions[i] = dir
		i.velocity = dir * move_speed

func set_can_move(val) -> void:
	can_move = val
	if can_move:
		change_directions()
	else:
		# Zero out velocities
		for i in node_directions:
			i.velocity *= int(can_move)
		stop_direction_change_timer()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		if event.is_pressed() and !event.is_echo():
			can_move = not can_move

# TIMER ------------------------------------------------------------------------
func start_direction_change_timer(one_shot := false) -> void:
	stop_direction_change_timer()
	direction_change_timer = get_tree().create_timer(direction_change_interval)
	direction_change_timer.timeout.connect(change_directions)
	if not one_shot:
		direction_change_timer.timeout.connect(start_direction_change_timer)

func stop_direction_change_timer() -> void:
	if direction_change_timer:
		for m in ["change_directions", "start_direction_change_timer"]:
			if direction_change_timer.timeout.is_connected(Callable(self, m)):
				direction_change_timer.timeout.disconnect(Callable(self, m))
