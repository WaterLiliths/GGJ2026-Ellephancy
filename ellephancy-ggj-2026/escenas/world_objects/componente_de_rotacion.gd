class_name ComponenteDeRotacion
extends Node

signal rotar

var angular_velocity := 0.0
var sensitivity := 0.01
var damping := 3.0
var max_speed := 4.0

func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("tirar"):
			angular_velocity += event.relative.y * sensitivity
			angular_velocity = clamp(angular_velocity, -max_speed, max_speed)


func _physics_process(delta):
	rotar.emit(rotacion(delta))

func rotacion(delta: float):
	var rot
	rot += angular_velocity * delta
	angular_velocity = move_toward(angular_velocity, 0.0, damping * delta)
	return rot
