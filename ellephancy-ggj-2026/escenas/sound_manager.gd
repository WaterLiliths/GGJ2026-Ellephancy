class_name SoundManager
extends Node

@export var player : Player

@onready var fmod_sonido_mascaras : FmodEventEmitter2D = %FmodEventEmitter2D6 #CAMBIAR NOMBRE AL NODO
@onready var fmod_sonido_salto : FmodEventEmitter2D  =%FmodEventEmitter2D2

#esta funcion se llama en la signal
func ejecutar_sonido_mascaras(mascara :String): #pasarle como parametro Oso Ciervo Salmon
	fmod_sonido_mascaras.set_parameter("Mascara", mascara)
	fmod_sonido_mascaras.play()


func ejecutar_sonido_salto():
	fmod_sonido_salto.play()


func _on_mascaras_manager_ejecutar_sonido_mascara(parametro: String) -> void:
	ejecutar_sonido_mascaras(parametro)
