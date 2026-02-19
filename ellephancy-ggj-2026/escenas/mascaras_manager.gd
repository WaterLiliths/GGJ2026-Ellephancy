class_name MascarasManager
extends Node

@export var sound_manager : SoundManager
@export var player : Player
@onready var mascara_oso : Node2D = %MascaraFuerza
@onready var mascara_ciervo : Node2D = %MascaraTiempos
@onready var mascara_salmon : Node2D = %MascaraTraducciones


func usar_mascara_oso():
	if puedo_usar_mascara(2)== false: #dice 2 porque quedo que la del oso era la 2, a cambiar
		return
	mascara_oso.usar()
	mascara_ciervo.desactivar()
	mascara_salmon.desactivar()
	sound_manager.ejecutar_sonido_mascaras("Oso")

func usar_mascara_salmon():
	if puedo_usar_mascara(1)== false: #en global la 1 es ciervo
		return
	mascara_oso.desactivar()
	mascara_ciervo.desactivar()
	mascara_salmon.usar()
	sound_manager.ejecutar_sonido_mascaras("Salmon")

func usar_mascara_ciervo():
	if puedo_usar_mascara(3)== false: #en global la 3 es salmon
		return
	mascara_oso.desactivar()
	mascara_ciervo.usar()
	mascara_salmon.desactivar()
	sound_manager.ejecutar_sonido_mascaras("Ciervo")



func puedo_usar_mascara(id_mascara : int): #TERMINAR
	if Global.mascara_activa==id_mascara:
		return false #no usarla si ya estaba activa
	match id_mascara:
		1: #cambiar despues pq 
			if not Global.tiene_mascara_tiempo:
				print("no tengo la mascara del tiempo")
				return false
			return true
		2:
			if not Global.tiene_mascara_fuerza:
				print("no tengo la mascara de la fuerza")
				return false
			return true
		3:
			if not Global.tiene_mascara_traducciones:
				print("no tengo la mascara de las traducciones")
				return false
			return true
