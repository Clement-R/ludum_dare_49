extends Control

var _texture_progress: TextureProgress

func _ready() -> void:
	Events.connect("tap_cooldown", self, "_on_tap_cooldown")
	Events.connect("tap_cooldown_end", self, "_on_tap_cooldown_end")
	
	_texture_progress = $TextureProgress
	_on_tap_cooldown_end()

func _on_tap_cooldown(progress: float) -> void:
	_texture_progress.value = progress * 100
	
func _on_tap_cooldown_end() -> void:
	_texture_progress.value = 0
