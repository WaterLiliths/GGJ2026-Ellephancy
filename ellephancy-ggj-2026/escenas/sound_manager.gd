class_name SoundManager
extends Node

@export var player : Player

@onready var fmod_sonido_mascaras : FmodEventEmitter2D = %FmodEventEmitter2D6 #CAMBIAR NOMBRE AL NODO


func ejecutar_sonido_mascaras(mascara :String): #pasarle como parametro Oso Ciervo Salmon
	fmod_sonido_mascaras.set_parameter("Mascara", mascara)
	fmod_sonido_mascaras.play()
