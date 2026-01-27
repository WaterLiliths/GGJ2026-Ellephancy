extends Node2D


@onready var sprite_traducido: Sprite2D = %SpriteTraducido
@onready var sprite_runa: Sprite2D = %SpriteRuna

func _ready() -> void:
	sprite_traducido.hide()
	Global.mascara_traducciones_activa.connect(on_mascara_traducciones_activa)



func on_mascara_traducciones_activa():
	sprite_runa.hide()
	sprite_traducido.show()
