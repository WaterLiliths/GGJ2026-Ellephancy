class_name Manivela extends Node2D

var player_dentro_del_area : bool = false
var velocidad_angular := 0.0
var sensitivity := 0.005
var damping := 3.0
var max_speed := 5.0
var rotando : bool = false

signal manivela_moviendo(direccion : float)

func _input(event):
	if event is InputEventMouseMotion:
		if player_dentro_del_area and Input.is_action_pressed("tirar"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			velocidad_angular += event.relative.x * sensitivity
			velocidad_angular = clamp(velocidad_angular, -max_speed, max_speed)
			
		#else:
			#sonido_rotacion.stop()
	if Input.is_action_just_released("tirar"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#sonido_rotacion.stop()


func _physics_process(delta):
	aplicar_velocidad_angular(delta)


func aplicar_velocidad_angular(delta):
	rotation += velocidad_angular * delta
	velocidad_angular = move_toward(velocidad_angular, 0.0, damping * delta)
	manivela_moviendo.emit(velocidad_angular)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_dentro_del_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_dentro_del_area = false
