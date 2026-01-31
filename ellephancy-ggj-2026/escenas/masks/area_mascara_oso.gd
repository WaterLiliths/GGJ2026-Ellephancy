extends Area2D

#-------------SEÑALES------------
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if Input.is_action_just_pressed("interactuar"):
			tomar_mascara()

#-------------FUNCIONES--------------
func tomar_mascara():
	Global.tiene_mascara_fuerza = true
	queue_free()
