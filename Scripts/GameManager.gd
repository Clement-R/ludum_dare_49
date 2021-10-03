extends Node

export (PackedScene) var _main_menu

var _main_menu_instance: Node

func _ready() -> void:
	Events.connect("go_to_main_menu", self, "_show_main_menu")

func _show_main_menu() -> void:
	_main_menu_instance = _main_menu.instance()
	add_child(_main_menu_instance)
