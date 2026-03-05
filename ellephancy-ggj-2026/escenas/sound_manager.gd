class_name SoundManager
extends Node

@export var player : Player
@onready var fmod_sonido_mascaras : FmodEventEmitter2D = %FmodEventEmitter2D6 #CAMBIAR NOMBRE AL NODO
@onready var fmod_sonido_salto : FmodEventEmitter2D  =%FmodEventEmitter2D2
var sonido_caja_sonando : bool = false

func _physics_process(delta: float) -> void:
	#copie y pegue literal de player estos 3 .volume
	%FmodEventEmitter2D.volume = Global.volumen_efectos
	%FmodEventEmitter2D4.volume = Global.volumen_efectos
	%FmodEventEmitter2D2.volume = Global.volumen_efectos

#esta funcion se llama en la signal
func ejecutar_sonido_mascaras(mascara :String): #pasarle como parametro Oso Ciervo Salmon
	fmod_sonido_mascaras.set_parameter("Mascara", mascara)
	fmod_sonido_mascaras.play()


func ejecutar_sonido_salto():
	fmod_sonido_salto.play()

func emitir_sonido_caida():
	if player.estaba_en_el_piso and not player.is_on_floor():
		%FmodEventEmitter2D5.play()
		player.sonido_caida_emitiendo = true

func ejecutar_sonido_pasos():
	%FmodEventEmitter2D.play()

#func ejecutar_sonido_arrastrar(peso : float):
	##se llama desde movimiento manager, SOLO en el estado de agarrar
	#if sonido_caja_sonando:
		#return
	#%FmodEventEmitter2D3.set_parameter("peso", peso)
	#%FmodEventEmitter2D3.play()
	#sonido_caja_sonando = true
#
#func detener_sonido_arrastrar(): #es llamado por movimiento manager en estado AGARRAR
	#sonido_caja_sonando = false
	#%FmodEventEmitter2D3.stop()


func _on_mascaras_manager_ejecutar_sonido_mascara(parametro: String) -> void:
	ejecutar_sonido_mascaras(parametro)
