class_name Mascara
extends Node

@export var id : int
@export var activa : bool = false


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
