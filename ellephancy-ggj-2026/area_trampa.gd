class_name AreaTrampa
extends Node2D

@export var colision : CollisionShape2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.restart.emit()
