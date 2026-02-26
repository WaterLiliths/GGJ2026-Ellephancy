extends Node

signal mascara_traducciones_activa
signal mascara_tiempo_activa(id : int)
signal mascara_fuerza_activa
signal mascara_traducciones_desactivar
signal mascara_tiempo_desactivar
signal mascara_fuerza_desactivar
signal agarre_mascara(id : int)
signal equipar_mascara(id : int)
#Booleano por mascara
var tiene_mascara_fuerza : bool = false
var tiene_mascara_tiempo : bool = false
var tiene_mascara_traducciones : bool = false


signal matar_player #emitida desde player y escuchada por JUEGO, es para hacer el fade out
signal dialogo_activo_to_player #se emite en area dialogo
signal dialogo_desactivado_to_player #se escucha player
signal restart #agregada para el boton de estoy atascado, solo para el showcase?
signal player_detecto_caida(tiempo_en_aire : float) #emitida por player y escuchada por juego, para la mini animacion de la camara

var mascara_activa : int = 0
#----------------PALANCA Y PUERTA------------------
signal activar_palanca(id_palanca : int)
signal desactivar_palanca(id_palanca : int)

signal puerta_abierta(position)
signal tipo_de_suelo

signal cambiar_volumen

var volumen_general : float = 0.8
var volumen_musica : float = 1.0 * volumen_general
var volumen_efectos : float = 1.0 * volumen_general
var volumen_ambiente : float = 1.0 * volumen_general

var checkpoint_position : Vector2


func set_checkpoint_position(nueva_pos : Vector2): #la llamo en escena checkpoint
	#if nueva_pos == checkpoint_position: #si son iguales, no la guardo, ya estuve en este checkpoint
	#	return
	checkpoint_position = nueva_pos
	print("La nueva posicion del checkpoint es : ", checkpoint_position)

func get_checkpoint_position(): #seguro la llame desde player
	return checkpoint_position


func guardar_datos():
	pass

func cargar_datos():
	pass
