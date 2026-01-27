extends Sprite2D



func _ready() -> void:
	Global.mascara_tiempo_activa.connect(on_mascara_tiempo_activa)



func on_mascara_tiempo_activa():
	texture = preload("res://assets/logo/EllePhancy2x.png")
