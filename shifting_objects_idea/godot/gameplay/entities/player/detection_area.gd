class_name DetectionArea
extends Area2D

var valid_areas : Array[Area2D] = []
var valid_bodies : Array[PhysicsBody2D] = []


func get_nearest_contained_body() -> PhysicsBody2D:
	return _get_nearest(get_overlapping_bodies())
	
func get_nearest_contained_area() -> Area2D:
	return _get_nearest(get_overlapping_areas())

func _get_nearest(arr : Array) -> Node2D:
	var nearest : Node2D = null
	var shortest_distance = INF
	for i in arr:
		var d = i.global_position.distance_squared_to(global_position)
		if d < shortest_distance:
			shortest_distance = d
			nearest = i
	return nearest
