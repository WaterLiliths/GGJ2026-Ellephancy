extends Control


@export var mascara : CompressedTexture2D

func _ready() -> void:
	$TextureRect.texture = mascara
