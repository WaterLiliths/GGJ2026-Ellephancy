extends Node2D


@export var escena_a_cambiar : PackedScene


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_packed(escena_a_cambiar)
