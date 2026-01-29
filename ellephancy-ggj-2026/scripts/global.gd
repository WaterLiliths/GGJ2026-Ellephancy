extends Node

signal mascara_traducciones_activa
signal mascara_tiempo_activa(id : int)
signal mascara_fuerza_activa
signal mascara_traducciones_desactivar
signal mascara_tiempo_desactivar
signal mascara_fuerza_desactivar

signal usar_palanca(id_palanca : int)
var mascara_activa : int = 0

func _ready() -> void:
	pass # Replace with function body.
