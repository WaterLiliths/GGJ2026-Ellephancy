class_name TrampaDeFlechas
extends Node2D

const FLECHA = preload("uid://ccj3cuygtcfio")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("disparar flecha"):
			disparar_flecha()

func disparar_flecha():
	var flecha : Flecha = FLECHA.instantiate()
	flecha.position = Vector2.LEFT * 30
	add_child(flecha)
	flecha.z_index = -1
	flecha.linear_velocity = Vector2.LEFT * 2000
