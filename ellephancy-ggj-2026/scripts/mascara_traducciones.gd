extends Node2D #mascara de las traducciones es 3

@export var id : int = 3
@export var activa : bool = false


func _ready() -> void:
	pass

func usar():
	if activa:
		return
	activa = true
	Global.mascara_activa = id
	Global.mascara_traducciones_activa.emit()
	print("se uso la mascara de traducciones")




func desactivar():
	if not activa: #si ya estaba desactivada
		return
	activa = false
	Global.mascara_traducciones_desactivar.emit()
