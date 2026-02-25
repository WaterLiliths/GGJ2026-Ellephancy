extends Node2D

@export var parallax_layers: Array[Parallax2D] = []
@export var parallax_sprites: Array[Sprite2D] = []

@export var layer_strengths: Array[float] = [0.02, 0.05, 0.08, 0.12, 0.18]
@export var smoothing: float = 5.0

var screen_center: Vector2
var target_offsets: Array[Vector2] = []


func _ready() -> void:
	screen_center = get_viewport().get_visible_rect().size / 2.0
	target_offsets.resize(parallax_layers.size())
	target_offsets.fill(Vector2.ZERO)
	for sprite in parallax_sprites:
		sprite.offset = get_viewport_rect().size / 3
		sprite.scale = Vector2(1.5, 1.5)


func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var offset = mouse_pos - screen_center
	for i in range(parallax_layers.size()):
		if i >= parallax_layers.size():
			break
		var strength = layer_strengths[i] if i < layer_strengths.size() else 0.05
		target_offsets[i] = -offset * strength
		parallax_layers[i].scroll_offset = parallax_layers[i].scroll_offset.lerp(
			target_offsets[i], smoothing * delta
		)
