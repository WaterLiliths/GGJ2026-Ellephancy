extends StaticBody2D

@export var varias_palancas : bool = false
@export var id_puerta : int = 0

func _ready() -> void:
	Global.usar_palanca.connect(abrir_puerta)

func _process(delta: float) -> void:
	pass
	
#------------------FUNCIONES-----------------------
func abrir_puerta(id_palanca : int):
	if id_palanca != id_puerta:
		print("palanca equivocada")
		return
	elif id_palanca == id_puerta:
		%AnimationPuerta.play("abir_sprite")
