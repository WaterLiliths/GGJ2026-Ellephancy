extends Node2D

var activada : bool = false #bandera para evitar que spawneen la tecla de esta mascara


func _ready() -> void:
	Global.mascara_traducciones_activa.connect(on_mascara_traducciones_activa)

func usar():
	if activada:
		return
	print("USAMOS LA MASCARA")
	Global.mascara_tiempo_activa.emit()
	activada = true


func on_mascara_traducciones_activa():
	activada = false
