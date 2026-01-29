extends Node2D #mascara de los tiempos la 1

@export var id : int = 1
@export var activa : bool = false


func _ready() -> void:
	pass

func usar():
	if activa:
		return
	activa = true
	Global.mascara_activa = id
	Global.mascara_tiempo_activa.emit()
	print("se uso la mascara de tiempos")




func desactivar():
	if not activa: #si ya estaba desactivada
		return
	activa = false
	Global.mascara_tiempo_desactivar.emit()
