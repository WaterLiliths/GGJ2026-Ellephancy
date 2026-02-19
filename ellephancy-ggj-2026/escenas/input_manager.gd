class_name InputManager
extends Node

@export var player : Player
@export var sound_manager : SoundManager
@export var mascaras_manager : MascarasManager
@export var animation_manager : AnimationManager

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"): #usar mascara fuerza
		mascaras_manager.usar_mascara_oso() #DSP LLAMADAS POR SEÑALES NO DIRECTAS
	animation_manager.verificar_animacion_con_mascara()
	if Input.is_action_just_pressed("2"): #usar mascara tiempos
		mascaras_manager.usar_mascara_ciervo()
	animation_manager.verificar_animacion_con_mascara()
	if Input.is_action_just_pressed("3"): #usar mascara traducciones
		mascaras_manager.usar_mascara_salmon()
	animation_manager.verificar_animacion_con_mascara()

	if Input.is_action_just_pressed("tirar") and Global.mascara_activa==2 and player.objeto_arrastrado:
		if not player.agarrando_caja:
			player.agarrar_caja()
		else:
			player.soltar_caja()

	if Input.is_action_just_pressed("r"):
		print("Se apreto la R")
		player.restart() #en restart llamo a matar jugador, te lleva al checkpoint
