extends Node2D


func _physics_process(_delta: float) -> void:
	position = get_local_mouse_position() * 1
