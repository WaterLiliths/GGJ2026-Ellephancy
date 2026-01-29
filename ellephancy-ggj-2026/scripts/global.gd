extends Node

signal mascara_traducciones_activa
signal mascara_tiempo_activa(id : int)
signal mascara_fuerza_activa
signal mascara_traducciones_desactivar
signal mascara_tiempo_desactivar
signal mascara_fuerza_desactivar


var mascara_activa : int = 0
#----------------PALANCA Y PUERTA------------------
signal activar_palanca(id_palanca : int)
signal desactivar_palanca(id_palanca : int)



func _ready() -> void:
	pass # Replace with function body.
