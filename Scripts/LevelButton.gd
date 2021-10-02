extends Control

var level_index = 0 setget _set_level
var level: PackedScene
var locked = true setget _set_locked

var _label: Label
var _locked_ui: Control

func _ready() -> void:
	_label = $Label
	_locked_ui = $Locked

func _set_level(level: int) -> void:
	level_index = level
	_label.text = str(level + 1)

func _set_locked(state: bool) -> void:
	locked = state
	_locked_ui.visible = locked

func _on_ToolButton_pressed() -> void:
	LevelsManager.load_level(level)
