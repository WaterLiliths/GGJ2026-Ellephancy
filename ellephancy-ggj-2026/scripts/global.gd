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


func _ready() -> void:
	cargar_datos()

func set_checkpoint_position(nueva_pos : Vector2): #la llamo en escena checkpoint
	#if nueva_pos == checkpoint_position: #si son iguales, no la guardo, ya estuve en este checkpoint
	#	return
	checkpoint_position = nueva_pos
	print("La nueva posicion del checkpoint es : ", checkpoint_position)

func get_checkpoint_position(): #seguro la llame desde player
	return checkpoint_position


#---------------------- guardar y cargar datos ---------------------------
#INFO IMPORTANTE a esta funcion de guardar datos la llamamos directamente, pero si se quisiera podriamos hacer una signal
#ejemplo, voy al checkpoint y en la misma funcion donde se setea el checkpoint position le pongo Global.guardar_datos()


#INFO: Por ahora guardar datos se llama en:
#1- cuando entramos a un checkpoint
#2- Cuando apretamos el boton salir y salimos al menu de inicio
#3- Cuando agarro una mascara en alguno de los altares
func guardar_datos(): 
	var config = ConfigFile.new()
	config.set_value("ningu_saves_player", "checkpoint", checkpoint_position)
	config.set_value("ningu_saves_player", "tiene_mascara_fuerza", tiene_mascara_fuerza)
	config.set_value("ningu_saves_player", "tiene_mascara_traducciones", tiene_mascara_traducciones)
	config.set_value("ningu_saves_player", "tiene_mascara_tiempo", tiene_mascara_tiempo)
	config.set_value("ningu_saves_player", "mascara_activa", mascara_activa)
	config.save("user://ningu_config_file.cfg")


func cargar_datos():
	var config = ConfigFile.new()
	if config.load("user://ningu_config_file.cfg") == OK: #ok es q no dio errores
		checkpoint_position = config.get_value("ningu_saves_player", "checkpoint", Vector2.ZERO) #el ultimo parametro es el default por si no habia nada guardado ahi
		tiene_mascara_fuerza = config.get_value("ningu_saves_player", "tiene_mascara_fuerza", false)
		tiene_mascara_traducciones = config.get_value("ningu_saves_player", "tiene_mascara_traducciones", false)
		tiene_mascara_tiempo = config.get_value("ningu_saves_player", "tiene_mascara_tiempo", false)
		mascara_activa = config.get_value("ningu_saves_player", "mascara_activa", 0)
		get_tree().call_group("persistente", "cargar")
	else:
		print("No se encontro un archivo para cargar")

#---------------------- guardar y cargar datos ---------------------------
