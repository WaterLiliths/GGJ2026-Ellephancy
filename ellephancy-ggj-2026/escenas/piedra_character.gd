class_name Caja
extends CharacterBody2D

var direccion : int = 0
var velocidad : float = 0.0
var siendo_agarrada : bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if siendo_agarrada:
		velocity.x = direccion * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0, 800 * delta)

	move_and_slide()
