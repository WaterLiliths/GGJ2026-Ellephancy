extends Node


func activar():
	if estaba_activa():
		return
	activa = true


func desactivar():
	if not estaba_activa():
		return
	activa = false
	print("se desactivo")


func estaba_activa():
	if activa:
		return true
