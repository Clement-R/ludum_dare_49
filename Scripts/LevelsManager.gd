extends Node

export (Array, PackedScene) var _levels

var _current_level = null
var _current_level_index = 0
var _current_level_instance = null

var score_file = "user://score.save"

func _ready() -> void:
	Events.connect("next_level", self, "_load_next_level")
	Events.connect("retry_level", self, "_reload_level")
	Events.connect("go_to_main_menu", self, "_destroy_level_instance")
	
	var highest = get_highest_level_completed()
	if highest > 0:
		print(highest)
		_set_current_level(highest - 1)

func current_is_last_level() -> bool:
	return _current_level_index == len(_levels) - 1

# DEBUG TO REMOVE
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		_reset_score()

func _reload_level() -> void:
	if not _current_level_instance == null:
		_current_level_instance.queue_free()	

	_spawn_level(_current_level.resource_path)

func get_all_levels() -> Array:
	return _levels
	
func _set_current_level(level_index: int) -> void:
	_current_level = _levels[level_index]
	_current_level_index = level_index

func _get_next_level_path() -> String:
	if len(_levels) == 0:
		print("No levels set")
		return ""
	
	if _current_level == null:
		_current_level = _levels[0]
		_current_level_index = 0
	else:
		var index = _levels.find(_current_level)
		if index + 1 < len(_levels):
			_current_level = _levels[index + 1]
			_current_level_index = index + 1
			save_score()

	return _current_level.resource_path

func load_level(level: PackedScene) -> void:
	var index = _levels.find(level)
	if index == -1:
		return
		
	_current_level = level
	_current_level_index = index
	_spawn_level(level.resource_path)
	
func _load_next_level() -> void:
	var level_path = _get_next_level_path()
	if level_path == "":
		return
		
	_destroy_level_instance()
	_spawn_level(level_path)

func _destroy_level_instance() -> void:
	if not _current_level_instance == null:
		_current_level_instance.queue_free()

func get_highest_level_completed() -> int:
	var file = File.new()
	if not file.file_exists(score_file):
		return -1
	
	file.open(score_file, File.READ)
	return file.get_var()

func save_score():
	var file = File.new()
	file.open(score_file, File.WRITE)
	file.store_var(_current_level_index)
	file.close()
	
func _reset_score():
	var dir = Directory.new()
	dir.remove(score_file)

func _spawn_level(level_path: String) -> void:
	var level_instance = load(level_path).instance()
	add_child(level_instance)
	level_instance.position = Vector2.ZERO
	_current_level_instance = level_instance
	Events.emit_signal("load_level", _current_level_index)
