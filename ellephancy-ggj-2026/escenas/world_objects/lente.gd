class_name Lente
extends Node2D

const HAZ_DE_LUZ = preload("uid://cpyhe3nqkhc1v")



@export var iniciador : bool = false
@export var es_movible : bool = false
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sonido_rotacion: FmodEventEmitter2D = $SonidoRotacion
@onready var collision_shape_2d: CollisionShape2D = $AreaDeInteraccion/CollisionShape2D

var player_dentro_del_area : bool = false

var velocidad_angular := 0.0
var sensitivity := 0.001
var damping := 3.0
var max_speed := 5.0
var rotando : bool = false
@export var id_haz_iniciador : int = 0


func _ready() -> void:
	if not es_movible:
		collision_shape_2d.disabled = true
	
	if iniciador:
		var haz = HAZ_DE_LUZ.instantiate()
		haz.id_haz = id_haz_iniciador
		add_child(haz)

func _input(event):
	if event is InputEventMouseMotion:
		if player_dentro_del_area and Input.is_action_pressed("tirar"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			velocidad_angular += event.relative.x * sensitivity
			velocidad_angular = clamp(velocidad_angular, -max_speed, max_speed)
		else:
			sonido_rotacion.stop()
	if Input.is_action_just_released("tirar"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		sonido_rotacion.stop()



func _physics_process(delta):
	rotation += velocidad_angular * delta
	velocidad_angular = move_toward(velocidad_angular, 0.0, damping * delta)
	sonido_rotacion.set_parameter("velocidad_angular", abs(velocidad_angular))
	if velocidad_angular == 0.0:
		sonido_rotacion.play(true)


func _on_area_de_interaccion_body_entered(body: Node2D) -> void:
	if body is Player:
		player_dentro_del_area = true


func _on_area_de_interaccion_body_exited(body: Node2D) -> void:
	if body is Player:
		player_dentro_del_area = false
