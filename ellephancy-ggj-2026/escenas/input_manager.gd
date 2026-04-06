class_name InputManager
extends Node
##POR AHORA CONTROLA TODO MENOS W A S D y palanca

@export var player : Player
@export var sound_manager : SoundManager
@export var mascaras_manager : MascarasManager
@export var animation_manager : AnimationManager
signal tirar_presionado
signal interactuar_presionado

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"): #usar mascara fuerza
		Global.equipar_mascara.emit(2) #no olvidar que la 2 quedo como OSO
	animation_manager.verificar_animacion_con_mascara() #TODO Esto mas adelante tiene que ser una signal
	if Input.is_action_just_pressed("2"): #usar mascara tiempos
		Global.equipar_mascara.emit(1) #y la 1 quedo como ciervo, TODO cambiar cuando recupere neuronas
	animation_manager.verificar_animacion_con_mascara()
	if Input.is_action_just_pressed("3"): #usar mascara traducciones
		Global.equipar_mascara.emit(3)
	animation_manager.verificar_animacion_con_mascara()

	if Input.is_action_just_pressed("tirar"):
		tirar_presionado.emit()

	#if Input.is_action_just_pressed("interactuar"): #TODO hacer esto cuando estemos en llamada pq no quiero romper la palanca ah
		#interactuar_presionado.emit()

	if Input.is_action_just_pressed("r"):
		print("Se apreto la R")
		Global.restart.emit()
