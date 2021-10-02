extends Node2D

func _unhandled_input(event):
	if event.is_echo():
		return

	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			destroy_at_position(get_global_mouse_position())
	
	if event is InputEventScreenTouch and event.is_pressed():
		destroy_at_position(event.position)


func destroy_at_position(spawn_global_position):
	var space_state = get_world_2d().direct_space_state
	var results = space_state.intersect_point(spawn_global_position)
	for result in results:
		print(result.collider.name)
		result.collider.queue_free()
