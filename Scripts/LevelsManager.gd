extends Node

export (Array, PackedScene) var _levels

signal last_level_finished

var _current_level = null
var _current_level_index = 0
var _current_level_instance = null

var score_file = "user://score.save"

func _ready() -> void:
	Events.connect("next_level", self, "_load_next_level")
	Events.connect("retry_level", self, "_reload_level")
	
	var highest = get_highest_level_completed()
	print("Highest :", highest)

# DEBUG TO REMOVE
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		_load_next_level()
	
	if Input.is_action_just_pressed("ui_down"):
		_reset_score()

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
		if index + 1 < len(_levels):
			_current_level = _levels[index + 1]
			_current_level_index = index
			save_score()
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

func get_highest_level_completed() -> int:
	var file = File.new()
	if not file.file_exists(score_file):
		return -1
	
	file.open(score_file, File.READ)
	return file.get_var()

func save_score():
	var file = File.new()
	file.open(score_file, File.WRITE)
	file.store_var(_current_level_index + 1)
	file.close()
	
func _reset_score():
	var dir = Directory.new()
	dir.remove(score_file)

func _spawn_level(level_path: String) -> void:
	var level_instance = load(level_path).instance()
	add_child(level_instance)
	level_instance.position = Vector2.ZERO
	_current_level_instance = level_instance
