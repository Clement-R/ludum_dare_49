extends Node2D

export (Array, Resource) var _destroy_sounds

var _tap_timer: Timer
var _last_destroy_sound = -1
var _destroy_sound_direction = 1

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
	var destroyed = false
	for result in results:
		if(result.collider.name in ["Ground", "Trophy"]):
			continue
		result.collider.queue_free()
		destroyed = true
	
	if destroyed:
		_tap_timer.start()
		Events.emit_signal("tap")
		AudioManager.play(_get_destroy_sound())

func _on_TapCooldown_timeout() -> void:
	Events.emit_signal("tap_cooldown_end")

func _get_destroy_sound() -> String:
	if _last_destroy_sound == -1:
		_last_destroy_sound = 0
		return _destroy_sounds[0].resource_path
	else:
		var index = _last_destroy_sound + _destroy_sound_direction
		if index >= len(_destroy_sounds):
			_destroy_sound_direction = -1
			index = _last_destroy_sound - 1
		elif index < 0:
			_destroy_sound_direction = 1
			index = _last_destroy_sound + 1
		
		_last_destroy_sound = index
		return _destroy_sounds[index].resource_path


func _on_TrophyZone_body_entered(body: Node) -> void:
	pass # Replace with function body.
