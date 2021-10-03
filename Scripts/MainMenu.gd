extends Control

export (PackedScene) var _selection_menu

var _selection_menu_instance_path: String
var _next_level_label
var _trophy: Control

func _ready() -> void:
	Events.connect("load_level", self, "_on_load_level")
	
	var highest = LevelsManager.get_highest_level_completed()
	if highest == -1:
		highest = 1
	else:
		highest += 1

	var next_level = highest
	_next_level_label = $Play/NextLevel
	_next_level_label.text = "Level %s" % str(next_level)
	
	_trophy = $AnimationPlayer/Trophy

func _process(delta: float) -> void:
	_trophy.visible = _selection_menu_instance_path == "" or get_node(_selection_menu_instance_path) == null

func _on_LevelSelection_pressed() -> void:
	var selection_menu_instance = _selection_menu.instance()
	add_child(selection_menu_instance)
	_selection_menu_instance_path = selection_menu_instance.get_path()

func _on_Play_pressed() -> void:
	Events.emit_signal("next_level")

func _on_load_level(level_index: int) -> void:
	queue_free()
