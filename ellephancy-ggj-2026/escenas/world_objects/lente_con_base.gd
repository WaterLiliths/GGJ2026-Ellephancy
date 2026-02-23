class_name BaseLente
extends RigidBody2D

@export_enum("LENTE", "ESPEJO") var tipo_de_optica = "LENTE"
@export var fijo : bool = false
@export var optica_rotable : bool = true
@export var emisor : bool = false

const LENTE = preload("uid://ddadtanp2707x")
const ESPEJO = preload("uid://dg6y4xunbnxvq")

var optica

func _ready() -> void:
	if fijo:
		freeze = true
	match tipo_de_optica:
		"LENTE":
			var lente = LENTE.instantiate()
			optica = lente
			if emisor == true:
				optica.iniciador = true
			add_child(lente)
		"ESPEJO":
			var espejo = ESPEJO.instantiate()
			add_child(espejo)
			optica = espejo
	if not optica_rotable:
		optica.es_rotable = false

	

func _physics_process(delta: float) -> void:
	optica.global_position = position + Vector2.UP * 32
