extends Area2D

var player_cerca : bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interactuar") and player_cerca:
		tomar_mascara()

#-------------FUNCIONES--------------
func tomar_mascara():
	Global.tiene_mascara_tiempo = true
	Global.agarre_mascara.emit("ciervo")
	queue_free()


#---------------SEÑALES--------------
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_cerca = true




func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_cerca = false
