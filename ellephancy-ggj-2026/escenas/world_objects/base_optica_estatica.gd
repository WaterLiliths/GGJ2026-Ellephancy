class_name BaseLenteEstatica
extends Node2D

@export_enum("LENTE", "ESPEJO") var tipo_de_optica : int = 0
@export var optica_rotable : bool = true
@export var rotacion_inicial : int = 0
@export var emisor : bool = false

const LENTE = preload("uid://ddadtanp2707x")
const ESPEJO = preload("uid://dg6y4xunbnxvq")

var optica

func _ready() -> void:
	match tipo_de_optica:
		0:
			var lente = LENTE.instantiate()
			optica = lente
			if emisor == true:
				optica.iniciador = true
			add_child(lente)
		1:
			var espejo = ESPEJO.instantiate()
			add_child(espejo)
			optica = espejo
	if not optica_rotable:
		optica.es_rotable = false
	optica.rotation_degrees = -rotacion_inicial
