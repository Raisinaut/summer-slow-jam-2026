class_name DetectionArea
extends Area2D

var nodes_in_area : Array[Node2D] = []


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func get_nearest_contained_node() -> Node2D:
	var nearest : Node2D = null
	var shortest_distance = INF
	for i in nodes_in_area:
		var d = i.global_position.distance_squared_to(global_position)
		if d < shortest_distance:
			shortest_distance = d
			nearest = i
	return nearest


# SIGNALS ----------------------------------------------------------------------
func _on_area_entered(area : Node2D) -> void:
	if area is Grabbable:
		nodes_in_area.append(area)

func _on_area_exited(area : Node2D) -> void:
	if area is Grabbable:
		nodes_in_area.erase(area)
