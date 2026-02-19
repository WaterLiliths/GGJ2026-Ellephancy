class_name EstadosManager
extends Node

@export var player : Player
@export var sound_manager : SoundManager
@export var mascaras_manager : MascarasManager
@export var animation_manager : AnimationManager
@export var input_manager : InputManager

enum ESTADOS {IDLE, CAMINAR, SALTAR, CAER, INTERACTUAR, AGARRAR, DIALOGO_ACTIVO}
var estado_actual : ESTADOS = ESTADOS.IDLE



#func cambiar_de_estado(estado_nuevo : ESTADOS):
	#if estado_actual == estado_nuevo:
		#return
	#ultimo_estado = estado_actual
	#estado_actual = estado_nuevo
	#match estado_actual:
		#ESTADOS.IDLE:
			#animation_manager.ejecutar_animacion_idle()
			#pass
		#ESTADOS.CAMINAR:
			#animation_manager.ejecutar_animacion_caminar()
			#pass
		#ESTADOS.SALTAR:
			#animation_manager.ejecutar_animacion_saltar()
			#%FmodEventEmitter2D2.play()
		#ESTADOS.CAER:
			#animation_manager.ejecutar_animacion_caida()
			#pass
		#ESTADOS.INTERACTUAR:
			#animation_manager.ejecutar_animacion_palanca()
			#pass
		#ESTADOS.AGARRAR:
			#animation_manager.ejecutar_animacion_arrastrar()
			#pass
		#ESTADOS.DIALOGO_ACTIVO:
			#animation_manager.ejecutar_animacion_idle()
			#pass


#func _physics_process(delta: float) -> void:
	#match estado_actual:
		#ESTADOS.IDLE:
			#procesar_idle(delta)
		#ESTADOS.CAMINAR:
			#procesar_caminar(delta)
		#ESTADOS.SALTAR:
			#procesar_saltar(delta)
		#ESTADOS.CAER:
			#procesar_caer(delta)
		#ESTADOS.INTERACTUAR:
			#pass #por si necesitan logica en process la ponemos aca
		#ESTADOS.AGARRAR:
			#procesar_agarrar(delta)
		#ESTADOS.DIALOGO_ACTIVO:
			#procesar_dialogo_activo(delta)
