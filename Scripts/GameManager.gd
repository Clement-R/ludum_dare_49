extends Node

export (PackedScene) var _main_menu

var _main_menu_instance: Node


func _show_main_menu() -> void:
	_main_menu_instance = _main_menu.instance()
	add_child(_main_menu_instance)
