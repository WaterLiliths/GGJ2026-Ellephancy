extends StaticBody2D

@export var id_puerta : int = 0
#@export var id_opcional : int = 0
@export var varias_palancas : bool = false
@export_range(1,3,1) var cant_palancas : int = 1

var contador_id : int = 0

func _ready() -> void:
	Global.usar_palanca.connect(abrir_puerta)

func _process(delta: float) -> void:
	pass
	
#------------------FUNCIONES-----------------------
func abrir_puerta(id_palanca : int):
	if id_palanca != id_puerta:
		print("palanca equivocada")
		return
	if !varias_palancas and id_palanca == id_puerta:
		%AnimationPuerta.play("abir_sprite")
	elif varias_palancas:
		contador_id += 1
		if contador_id != cant_palancas:
			return
		%AnimationPuerta.play("abir_sprite")
