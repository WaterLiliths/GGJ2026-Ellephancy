class_name Espejo
extends Node2D

var player_dentro_del_area
var angular_velocity := 0.0
var sensitivity := 0.007
var damping := 3.0
var max_speed := 4.0

func _input(event):
	if event is InputEventMouseMotion:
		if player_dentro_del_area and Input.is_action_pressed("tirar"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			angular_velocity += event.relative.y * sensitivity
			angular_velocity = clamp(angular_velocity, -max_speed, max_speed)
	if Input.is_action_just_released("tirar"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _physics_process(delta):
	rotation += angular_velocity * delta
	angular_velocity = move_toward(angular_velocity, 0.0, damping * delta)


func _on_area_de_interaccion_body_entered(body: Node2D) -> void:
	if body is Player:
		print("player entro al area de interaccion de la lente")
		player_dentro_del_area = true


func _on_area_de_interaccion_body_exited(body: Node2D) -> void:
	if body is Player:
		print("player salio del area de interaccion de la lente")
		player_dentro_del_area = false
