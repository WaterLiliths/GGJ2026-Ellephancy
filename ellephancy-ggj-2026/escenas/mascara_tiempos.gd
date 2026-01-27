extends Node2D

var activada : bool = false #bandera para evitar que spawneen la tecla de esta mascara


func usar():
	if activada:
		return
	print("uso mascara para cambiar tiempos")
	Global.mascara_tiempo_activa.emit()
	activada = true
#cuando se llame otra mascara se desactiva
