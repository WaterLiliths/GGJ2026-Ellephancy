class_name MascarasManager
extends Node

@export var sound_manager : SoundManager
@export var player : Player
@onready var mascara_oso : Node2D = %MascaraFuerza
@onready var mascara_ciervo : Node2D = %MascaraTiempos
@onready var mascara_salmon : Node2D = %MascaraTraducciones
enum MASCARAS {OSO, CIERVO, SALMON}
signal ejecutar_sonido_mascara(parametro : String)

func _ready() -> void:
	Global.equipar_mascara.connect(_on_equipar_mascara)
	Global.agarre_mascara.connect(_on_equipar_mascara)

func usar_mascara_oso():
	if puedo_usar_mascara(2)== false: #dice 2 porque quedo que la del oso era la 2, a cambiar
		print("no puedo usar mascara de oso")
		return
	mascara_oso.usar()
	mascara_ciervo.desactivar()
	mascara_salmon.desactivar()
	ejecutar_sonido_mascara.emit("Oso")
	#sound_manager.ejecutar_sonido_mascaras("Oso")

func usar_mascara_salmon():
	if puedo_usar_mascara(1)== false: #en global la 1 es ciervo
		print("no puedo usar mascara de ciervo")
		return
	mascara_oso.desactivar()
	mascara_ciervo.desactivar()
	mascara_salmon.usar()
	ejecutar_sonido_mascara.emit("Salmon")
	#sound_manager.ejecutar_sonido_mascaras("Salmon")

func usar_mascara_ciervo():
	if puedo_usar_mascara(3)== false: #en global la 3 es salmon
		print("no puedo usar mascara de salmon")
		return
	mascara_oso.desactivar()
	mascara_ciervo.usar()
	mascara_salmon.desactivar()
	ejecutar_sonido_mascara.emit("Ciervo")
	#sound_manager.ejecutar_sonido_mascaras("Ciervo")


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


func _on_equipar_mascara(id_mascara : int):
	match id_mascara:
		1:
			usar_mascara_ciervo()
		2:
			usar_mascara_oso()
		3:
			usar_mascara_salmon()


func resetear_mascaras_a_cero(estado : bool):
	if estado == true:
		Global.tiene_mascara_fuerza = false
		Global.tiene_mascara_tiempo = false
		Global.tiene_mascara_traducciones = false
		Global.mascara_activa = 0 #esto faltaba pq cuando terminabas el juego tenias la del oso puesta
	else: #esto lo agrego para que sea mas facil activar y desactivar con una sola funcion
		Global.tiene_mascara_fuerza = true
		Global.tiene_mascara_tiempo = true
		Global.tiene_mascara_traducciones = true
