class_name Espejo
extends Node2D

var player_dentro_del_area
var velocidad_angular := 0.0
var sensitivity := 0.001
var damping := 3.0
var max_speed := 5.0


@onready var area_de_interaccion: Area2D = $AreaDeInteraccion
@onready var collision_shape_2d: CollisionShape2D = $AreaDeInteraccion/CollisionShape2D
@onready var sonido_rotacion: FmodEventEmitter2D = $SonidoRotacion

@export var es_movible : bool = false

func _input(event):
	if not es_movible:
		collision_shape_2d.disabled = true
	
	if event is InputEventMouseMotion:
		if player_dentro_del_area and Input.is_action_pressed("tirar"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			velocidad_angular += event.relative.y * sensitivity
			velocidad_angular = clamp(velocidad_angular, -max_speed, max_speed)
	if Input.is_action_just_released("tirar"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		sonido_rotacion.stop()

func _physics_process(delta):
	rotation += velocidad_angular * delta
	velocidad_angular = move_toward(velocidad_angular, 0.0, damping * delta)
	sonido_rotacion.set_parameter("velocidad_angular", abs(velocidad_angular))
	if velocidad_angular == 0:
		sonido_rotacion.play(true)

func _on_area_de_interaccion_body_entered(body: Node2D) -> void:
	if body is Player:
		player_dentro_del_area = true


func _on_area_de_interaccion_body_exited(body: Node2D) -> void:
	if body is Player:
		player_dentro_del_area = false
