extends Node

export (Array, PackedScene) var _levels

signal last_level_finished

var _current_level = null
var _current_level_instance = null

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		load_next_level()
	
	# DEBUG TO REMOVE
	if Input.is_key_pressed(KEY_E):
		get_tree().reload_current_scene()

func get_next_level_path() -> String:
	if len(_levels) == 0:
		print("No levels set")
		return ""
	
	if _current_level == null:
		print("null")
		_current_level = _levels[0]
	else:
		var index = _levels.find(_current_level)
		print("index: ", index)
		if index + 1 < len(_levels):
			_current_level = _levels[index + 1]
		else:
			print("Last level finished")
			emit_signal("last_level_finished")
			return ""

	print("Next level: ", _current_level.resource_path)
	return _current_level.resource_path
	
func load_next_level() -> void:
	var level_path = get_next_level_path()
	if level_path == "":
		return
		
	if not _current_level_instance == null:
		_current_level_instance.queue_free()

	var level_instance = load(level_path).instance()
	add_child(level_instance)
	level_instance.position = Vector2.ZERO
	_current_level_instance = level_instance

func get_all_levels() -> Array:
	return _levels
