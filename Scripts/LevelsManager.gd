extends Node

export (Array, PackedScene) var _levels

signal last_level_finished

var _current_level = null
var _current_level_instance = null

func _ready() -> void:
	Events.connect("next_level", self, "_load_next_level")
	Events.connect("retry_level", self, "_reload_level")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		_load_next_level()

func _reload_level() -> void:
	if not _current_level_instance == null:
		_current_level_instance.queue_free()

	_spawn_level(_current_level.resource_path)

func get_all_levels() -> Array:
	return _levels

func _get_next_level_path() -> String:
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
	
func _load_next_level() -> void:
	var level_path = _get_next_level_path()
	if level_path == "":
		return
		
	if not _current_level_instance == null:
		_current_level_instance.queue_free()

	_spawn_level(level_path)

func _spawn_level(level_path: String) -> void:
	var level_instance = load(level_path).instance()
	add_child(level_instance)
	level_instance.position = Vector2.ZERO
	_current_level_instance = level_instance
