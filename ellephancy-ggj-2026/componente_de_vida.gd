class_name ComponenteDeVida
extends Node

@export var vida_maxima : int  = 100
var vida : int
signal muerte

func _ready() -> void:
	vida = vida_maxima

func recibir_daño(daño: int):
	vida -= daño
	if vida <= 0:
		muerte.emit()
