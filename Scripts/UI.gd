extends Control

var _texture_progress: TextureProgress

var _victory
var _lose
var _last_level

var _next_level_button
var _retry_button
var _level_label
var _level_index

func _ready() -> void:
	Events.connect("tap_cooldown", self, "_on_tap_cooldown")
	Events.connect("tap_cooldown_end", self, "_on_tap_cooldown_end")
	Events.connect("win", self, "_on_win")
	Events.connect("lose", self, "_on_lose")
	Events.connect("load_level", self, "_on_load_level")
	
	_level_label = $Level
	_level_index = $Level/Levelndex
	_texture_progress = $TapCooldown
	_victory = $Victory
	_lose = $Lose
	_last_level = $LastLevel
	_victory.visible = false
	_lose.visible = false
	_on_tap_cooldown_end()
	
	_level_label.visible = false

func _on_tap_cooldown(progress: float) -> void:
	_texture_progress.value = progress * 100
	
func _on_tap_cooldown_end() -> void:
	_texture_progress.value = 0

func _on_win() -> void:
	# shouldn't happen but if trophy breaks but fall stable	
	if _lose.visible:
		return

	if LevelsManager.current_is_last_level():
		_last_level.visible = true
	else:
		_victory.visible = true

func _on_lose() -> void:
	_lose.visible = true

func _on_NextLevel_pressed() -> void:
	Events.emit_signal("next_level")
	_victory.visible = false

func _on_Retry_pressed() -> void:
	Events.emit_signal("retry_level")
	_lose.visible = false

func _on_load_level(level_index: int) -> void:
	_level_label.visible = true
	_level_index.text = str(level_index + 1)

func _on_MainMenu_pressed() -> void:
	_last_level.visible = false
	Events.emit_signal("go_to_main_menu")

func _on_Restart_pressed() -> void:
	Events.emit_signal("retry_level")
