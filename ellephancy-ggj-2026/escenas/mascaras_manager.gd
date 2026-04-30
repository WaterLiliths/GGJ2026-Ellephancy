class_name MascarasManager
extends Node

@export var sound_manager : SoundManager
@export var player : Player
@export var STATS : PlayerStats
@onready var mascara_oso : MascaraOso = %MascaraFuerza
@onready var mascara_ciervo : MascaraCiervo = %MascaraTiempos
@onready var mascara_salmon : MascaraSalmon = %MascaraTraducciones
enum MASCARAS {OSO, CIERVO, SALMON} #si no me equivoco no se usa, TODO REVISAR
signal ejecutar_sonido_mascara(parametro : String)
signal usar_habilidad_mascara(id_mascara : int)

func _ready() -> void:
	Global.mascara_tiempo_desactivar.connect(on_desactivar_mascara_tiempo)
	Global.mascara_tiempo_activa.connect(on_activar_mascara_tiempo)
	Global.mascara_fuerza_activa.connect(activar_mascara_fuerza)
	Global.mascara_fuerza_desactivar.connect(desactivar_mascara_fuerza)
	Global.equipar_mascara.connect(_on_equipar_mascara)
	Global.agarre_mascara.connect(_on_equipar_mascara)
	usar_habilidad_mascara.connect(_on_usar_habilidad_mascara)

func usar_mascara_oso():
	if puedo_usar_mascara(2)== false: #dice 2 porque quedo que la del oso era la 2, a cambiar
		print("no puedo usar mascara de oso")
		return
	mascara_oso.usar()
	mascara_ciervo.desactivar()
	mascara_salmon.desactivar()
	#ejecutar_sonido_mascara.emit("Oso") #los sonidos ahora van en equipar
	#sound_manager.ejecutar_sonido_mascaras("Oso")

func usar_mascara_salmon():
	print("usar mascara salmon") #si
	if puedo_usar_mascara(3)== false:
		print("no puedo usar mascara de salmon")
		return
	mascara_oso.desactivar()
	mascara_ciervo.desactivar()
	mascara_salmon.usar()
	#ejecutar_sonido_mascara.emit("Salmon")
	#sound_manager.ejecutar_sonido_mascaras("Salmon")

func usar_mascara_ciervo():
	if puedo_usar_mascara(1)== false: 
		print("no puedo usar mascara de ciervo")
		return
	mascara_oso.desactivar()
	mascara_ciervo.usar()
	mascara_salmon.desactivar()
	#ejecutar_sonido_mascara.emit("Ciervo")
	#sound_manager.ejecutar_sonido_mascaras("Ciervo")


func puedo_usar_mascara(id_mascara : int): #TERMINAR
	#if Global.mascara_activa==id_mascara:
		#return false #no usarla si ya estaba activa
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
	Global.mascara_activa = id_mascara
	match id_mascara:
		1:
			#aca
			#usar_mascara_ciervo() #ahora esta es la unica q cambia (no se usa instantaneamente)
			ejecutar_sonido_mascara.emit("Ciervo")
			STATS.velocidad_salto = STATS.velocidad_salto_con_mascara
		2:
			ejecutar_sonido_mascara.emit("Oso")
			STATS.velocidad_salto = STATS.velocidad_inicial_salto
			usar_mascara_oso()
		3:
			#print("MATCH EN 3")
			usar_mascara_salmon()
			STATS.velocidad_salto = STATS.velocidad_inicial_salto
			ejecutar_sonido_mascara.emit("Salmon")


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


func on_activar_mascara_tiempo(): #ahora el ciervo salta mas alto
	STATS.velocidad_salto = STATS.velocidad_salto_con_mascara
	

func on_desactivar_mascara_tiempo(): 
	#STATS.velocidad_salto = STATS.velocidad_inicial_salto
	pass


func activar_mascara_fuerza():
	#WARNING esta linea tenemos que comentar cuando le quitemos el salto al oso
	#por ahora para testear los niveles se lo dejo
	#STATS.velocidad_salto = STATS.velocidad_salto_con_mascara
	pass #no lo borro todavia para testear cosas

func desactivar_mascara_fuerza():
	#esta linea tenemos que comentar cuando le quitemos el salto al oso
	#por ahora para testear los niveles se lo dejo
	STATS.velocidad_salto = STATS.velocidad_inicial_salto
	#print("se desactivo las mascara de fuerza")


func _on_usar_habilidad_mascara(id_mascara : int):
	match id_mascara:
		1:
			if Global.mascara_activa!=1:
				return
			if mascara_ciervo.activa:
				mascara_ciervo.desactivar()
			else:
				usar_mascara_ciervo()
				ejecutar_sonido_mascara.emit("Ciervo")
		#las otras por ahora nada pero queda la funcion lista para cuando metamos habilidades con F
		#a las otras mascaras :D
