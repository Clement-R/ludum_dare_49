extends Control

var _texture_progress: TextureProgress

var _victory
var _lose

var _next_level_button
var _retry_button
var _level_index

func _ready() -> void:
	Events.connect("tap_cooldown", self, "_on_tap_cooldown")
	Events.connect("tap_cooldown_end", self, "_on_tap_cooldown_end")
	Events.connect("win", self, "_on_win")
	Events.connect("lose", self, "_on_lose")
	Events.connect("load_level", self, "_on_load_level")
	
	_level_index = $Levelndex
	_texture_progress = $TapCooldown
	_victory = $Victory
	_lose = $Lose
	_victory.visible = false
	_lose.visible = false
	_on_tap_cooldown_end()

func _on_tap_cooldown(progress: float) -> void:
	_texture_progress.value = progress * 100
	
func _on_tap_cooldown_end() -> void:
	_texture_progress.value = 0

func _on_win() -> void:
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
	_level_index.text = str(level_index + 1)
