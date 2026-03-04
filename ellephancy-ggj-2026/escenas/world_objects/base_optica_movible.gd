@tool
class_name BaseLente
extends RigidBody2D

@export_enum("LENTE", "ESPEJO") var tipo_de_optica : int = 0
@export var fijo : bool = false
@export var optica_rotable : bool = true
@export var rotacion_inicial : int = 0
@export var emisor : bool = false

const LENTE = preload("uid://ddadtanp2707x")
const ESPEJO = preload("uid://dg6y4xunbnxvq")

var optica

func _ready() -> void:
	collision_layer = 0
	if fijo:
		freeze = true
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
	optica.position += Vector2.UP * 32
	optica.rotation_degrees = -rotacion_inicial
