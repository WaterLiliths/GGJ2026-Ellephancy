extends Node2D #mascara de fuerza es la 2

@export var id : int = 2
@export var activa : bool = false


func _ready() -> void:
	pass

func usar():
	if activa:
		return
	activa = true
	Global.mascara_activa = id
	Global.mascara_fuerza_activa.emit()
	print("se uso la mascara de fuerza")




func desactivar():
	if not activa: #si ya estaba desactivada
		return
	activa = false
	Global.mascara_fuerza_desactivar.emit()
	print("se desactivo la mascara de fuerza")
























#func _ready() -> void:
	#Global.usar_mascara.connect(on_recibir_signal_usar)
#
#func usar():
	#if estaba_activa():
		#return
	#Global.mascara_fuerza_activa.emit()
	#activar()
	#print("se uso la mascara de fuerza")
#
#
#func on_recibir_signal_usar(id_referencia : int):
	#if id_referencia == id:
		#usar()
	#else:
		#desactivar()
#
#func get_estado_activa():
	#return activa
