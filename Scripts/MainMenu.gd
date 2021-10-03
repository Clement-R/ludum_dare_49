extends Control

export (PackedScene) var _selection_menu

var _selection_menu_instance: Node
var _next_level_label

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

func _on_LevelSelection_pressed() -> void:
	_selection_menu_instance = _selection_menu.instance()
	add_child(_selection_menu_instance)

func _on_Play_pressed() -> void:
	Events.emit_signal("next_level")

func _on_load_level(level_index: int) -> void:
	queue_free()
