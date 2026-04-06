class_name AreaTrampa
extends Area2D

@export var colision : CollisionShape2D
@export var piedra : Empujable


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.set_collision_layer_value(1, false)
		Global.restart.emit()
		if piedra:
			piedra.z_index = 3
			piedra.global_position = body.global_position
