extends Control

export (PackedScene) var _level_button

var _container

func _ready() -> void:
	Events.connect("load_level", self, "_on_load_level")
	
	_container = $ScrollContainer/CenterContainer/GridContainer
	
	var levels = LevelsManager.get_all_levels()
	var highest = LevelsManager.get_highest_level_completed()

	var index = 0
	for level in levels:
		var button_instance = _level_button.instance()
		_container.add_child(button_instance)
		button_instance.level_index = index
		button_instance.level = level

		if index == 0:
			button_instance.locked = false
		else:
			button_instance.locked = highest < index;

		index += 1

func _on_CloseButton_pressed() -> void:
	queue_free()

func _on_load_level(level_index: int) -> void:
	queue_free()
