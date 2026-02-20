class_name Lente
extends Node2D

const HAZ_DE_LUZ = preload("uid://cpyhe3nqkhc1v")
@onready var sonido_rotacion: FmodEventEmitter2D = $SonidoRotacion

@export var iniciador : bool = false
@export var es_movible : bool = false
@onready var point_light_2d: PointLight2D = $PointLight2D


@onready var collision_shape_2d: CollisionShape2D = $AreaDeInteraccion/CollisionShape2D


var player_dentro_del_area : bool = false

var angular_velocity := 0.0
var sensitivity := 0.001
var damping := 3.0
var max_speed := 4.0
var rotando : bool = false


func _ready() -> void:
	if not es_movible:
		collision_shape_2d.disabled = true
	
	if iniciador:
		var haz = HAZ_DE_LUZ.instantiate()
		add_child(haz)
	sonido_rotacion.set_parameter("Peso", 5.0)

func _input(event):
	if event is InputEventMouseMotion:
		if player_dentro_del_area and Input.is_action_pressed("tirar"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			angular_velocity += event.relative.y * sensitivity
			angular_velocity = clamp(angular_velocity, -max_speed, max_speed)
	if Input.is_action_just_released("tirar"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		sonido_rotacion.stop()



func _physics_process(delta):
	rotation += angular_velocity * delta
	angular_velocity = move_toward(angular_velocity, 0.0, damping * delta)
	if angular_velocity == 0:
		sonido_rotacion.play(true)

func _on_area_de_interaccion_body_entered(body: Node2D) -> void:
	if body is Player:
		player_dentro_del_area = true


func _on_area_de_interaccion_body_exited(body: Node2D) -> void:
	if body is Player:
		player_dentro_del_area = false
