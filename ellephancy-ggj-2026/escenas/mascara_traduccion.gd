extends Node2D


var activada : bool = false #bandera para evitar que spawneen la tecla de esta mascara


func _ready() -> void:
	Global.mascara_tiempo_activa.connect(on_mascara_tiempo_activa)

func usar():
	if activada:
		return
	print("USAMOS LA MASCARA DE TRADUCCIONESS")
	Global.mascara_traducciones_activa.emit()
	activada = true
#cuando se llame otra mascara se desactiva


func on_mascara_tiempo_activa():
	activada = false #porque en este momento esta activa solamente la otra
