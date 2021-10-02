extends Node2D

var _tap_timer: Timer

func _ready() -> void:
	_tap_timer = $TapCooldown

func _process(delta: float) -> void:
	if not _tap_timer.is_stopped():
		Events.emit_signal("tap_cooldown", _tap_timer.time_left / _tap_timer.wait_time)

func _unhandled_input(event):
	if event.is_echo():
		return
	
	if not _tap_timer.is_stopped():
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
		if(result.collider.name in ["Ground", "Trophy"]):
			continue
		result.collider.queue_free()
		
		_tap_timer.start()
		Events.emit_signal("tap")

func _on_TapCooldown_timeout() -> void:
	Events.emit_signal("tap_cooldown_end")
