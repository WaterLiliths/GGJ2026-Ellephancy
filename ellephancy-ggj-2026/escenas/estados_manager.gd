class_name EstadosManager
extends Node

@export var player : Player
@export var sound_manager : SoundManager
@export var mascaras_manager : MascarasManager
@export var animation_manager : AnimationManager
@export var input_manager : InputManager

enum ESTADOS {IDLE, CAMINAR, SALTAR, CAER, INTERACTUAR, AGARRAR, DIALOGO_ACTIVO}
var estado_actual : ESTADOS = ESTADOS.IDLE
var ultimo_estado : ESTADOS


func cambiar_de_estado(estado_nuevo : ESTADOS):
	if estado_actual == estado_nuevo:
		return
	ultimo_estado = estado_actual
	estado_actual = estado_nuevo
	match estado_actual:
		ESTADOS.IDLE:
			animation_manager.ejecutar_animacion_idle()
		ESTADOS.CAMINAR:
			animation_manager.ejecutar_animacion_caminar()
		ESTADOS.SALTAR:
			animation_manager.ejecutar_animacion_saltar()
			sound_manager.ejecutar_sonido_salto()
		ESTADOS.CAER:
			animation_manager.ejecutar_animacion_caida()
		ESTADOS.INTERACTUAR:
			animation_manager.ejecutar_animacion_palanca()
		ESTADOS.AGARRAR:
			animation_manager.ejecutar_animacion_arrastrar()
		ESTADOS.DIALOGO_ACTIVO:
			animation_manager.ejecutar_animacion_idle()


func _physics_process(delta: float) -> void:
	match estado_actual:
		ESTADOS.IDLE:
			player.procesar_idle(delta)
		ESTADOS.CAMINAR:
			player.procesar_caminar(delta)
		ESTADOS.SALTAR:
			player.procesar_saltar(delta)
		ESTADOS.CAER:
			player.procesar_caer(delta)
		ESTADOS.INTERACTUAR:
			pass #por si necesitan logica en process la ponemos aca
		ESTADOS.AGARRAR:
			player.procesar_agarrar(delta)
		ESTADOS.DIALOGO_ACTIVO:
			player.procesar_dialogo_activo(delta)
