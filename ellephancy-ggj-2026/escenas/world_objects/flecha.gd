class_name Flecha
extends RigidBody2D

@export var componente_de_hurtbox : ComponenteDeHurtbox
@export var daño : int = 20

func _ready() -> void:
	componente_de_hurtbox.daño = daño
