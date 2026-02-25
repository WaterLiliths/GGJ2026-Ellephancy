class_name TrampaDeFlechas
extends Node2D

const FLECHA = preload("uid://ccj3cuygtcfio")
@export var area_de_activacion : Area2D
@export var rafaga: int = 1
@export var ilimitado : bool = true
@export var cargador : int = 20
@export var velocidad_de_disparo : int = 2000
@export var cadencia_de_disparo : float = 0.2

func _ready() -> void:
	area_de_activacion.body_entered.connect(_detectar_jugador)


func disparar_flecha():
	var flecha : Flecha = FLECHA.instantiate()
	add_child(flecha)
	flecha.z_index = -1
	flecha.linear_velocity = Vector2.LEFT.rotated(rotation) * velocidad_de_disparo
	cargador -= 1

func _detectar_jugador(body: Node2D):
	if body is Player:
		for r in rafaga:
			if cargador > 0 or ilimitado:
				disparar_flecha()
			await get_tree().create_timer(cadencia_de_disparo).timeout
