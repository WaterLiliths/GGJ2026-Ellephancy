class_name MobilePlatform
extends AnimatableBody2D


@export var speed : float = 200.0
@export var marker_start : Marker2D
@export var marker_final : Marker2D

@export var activadores : Array[Node2D] = []

var moving : bool
var acceleration : float = 50.0
var current_speed : float = 0.0

var start_position : Vector2
var final_position : Vector2 
var target_position : Vector2
var direction : Vector2

var palancas : Array[Palanca] = []
var activadores_activados : Array [Node2D] = []

func _ready() -> void:
	if (marker_start):
		start_position = marker_start.global_position
	else :
			start_position = global_position
	
	final_position = marker_final.global_position
	target_position = final_position
	
	Global.activar_mecanismo.connect(_on_mecanismo_activado)
	Global.desactivar_mecanismo.connect(_on_mecanismo_desactivado)


func _physics_process(delta: float) -> void:
	if activadores.size() <= 0:
		moving = true

	if moving:
		current_speed += acceleration * delta
		current_speed = min(current_speed, speed)
		start_moving(delta)
	
	else:
		current_speed = 0.0

#=========
#FUNCIONES
#=========

func start_moving(delta: float) -> void:
	direction = (target_position - global_position).normalized()

	var motion : Vector2 = direction * current_speed * delta

	var collision = move_and_collide(motion)

	if collision:

		if target_position == final_position:
			target_position = start_position
		else:
			target_position = final_position

	if global_position.distance_to(target_position) < 1:

		if target_position == final_position:
			target_position = start_position
		else:
			target_position = final_position


func stop_moving()-> void:
	moving = false
	


#=======
#SEÑALES
#=======

func _on_mecanismo_activado(mecanismo):
	if mecanismo in activadores:
		if mecanismo not in activadores_activados:
			activadores_activados.append(mecanismo)
		if activadores_activados == activadores and activadores.size() > 0:
			moving = true

func _on_mecanismo_desactivado(mecanismo):
	pass
	if mecanismo in activadores:
		if activadores_activados == activadores and activadores.size() > 0:
			stop_moving()
