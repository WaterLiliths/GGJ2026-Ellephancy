class_name BaseLenteEstatica
extends CharacterBody2D

@export_enum("Lente", "Espejo") var tipo_de_optica : int = 0
@export var optica_rotable : bool = true
@export var rotacion_inicial : int = 0
@export var emisor : bool = false

@export_group("Movimiento")
@export_enum("Horizontal", "Vertical") var tipo_de_movimiento : int = 0
@export var manivela : Manivela
@export var velocidad : float = 10

const LENTE = preload("uid://ddadtanp2707x")
const ESPEJO = preload("uid://dg6y4xunbnxvq")

var optica


func _ready() -> void:
	if manivela:
		manivela.manivela_moviendo.connect(_on_manivela_moviendo)
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


func _on_manivela_moviendo(direccion : float):
	match tipo_de_movimiento:
		0:
			velocity.x = direccion * velocidad
		1:
			velocity.y = direccion * velocidad
	move_and_slide()
