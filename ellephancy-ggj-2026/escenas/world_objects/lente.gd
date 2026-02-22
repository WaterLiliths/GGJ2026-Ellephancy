class_name Lente
extends Node2D

const HAZ_DE_LUZ = preload("uid://cpyhe3nqkhc1v")

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sonido_rotacion: FmodEventEmitter2D = $SonidoRotacion
@onready var collision_shape_2d: CollisionShape2D = $AreaDeInteraccion/CollisionShape2D
@onready var sonido_frenar: FmodEventEmitter2D = $SonidoFrenar
@onready var cuadro_optica: Sprite2D = $CuadroOptica

var player_dentro_del_area : bool = false
var velocidad_angular := 0.0
var sensitivity := 0.001
var damping := 3.0
var max_speed := 5.0
var rotando : bool = false

@export var iniciador : bool = false
@export var id_haz_iniciador : int = 0
@export var cantidad_de_rebotes_haz : int = 10

@export_group("Movimiento")
@export var es_movible : bool = false
@export var rotacion_limitada : bool = false
@export var limite_superior : float = 45.0
@export var limite_inferior : float = -45.0


func _ready() -> void:
	if not es_movible:
		collision_shape_2d.disabled = true
	
	if iniciador:
		var haz = HAZ_DE_LUZ.instantiate()
		haz.id_haz = id_haz_iniciador
		haz.rebotes = cantidad_de_rebotes_haz
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
	if rotacion_limitada:
		if (rotation_degrees > limite_inferior and rotation_degrees < limite_superior):
			aplicar_velocidad_angular(delta)
		elif rotation_degrees < limite_inferior or rotation_degrees > limite_superior:
			rotation_degrees = clampf(rotation_degrees, limite_inferior + 0.1, limite_superior - 0.1)
			sonido_frenar.set_parameter("velocidad_angular", velocidad_angular)
			sonido_frenar.play()
			velocidad_angular = 0
			

	else:
		aplicar_velocidad_angular(delta)
	#rotation += velocidad_angular * delta
	#velocidad_angular = move_toward(velocidad_angular, 0.0, damping * delta)
	sonido_rotacion.set_parameter("velocidad_angular", abs(velocidad_angular))
	if velocidad_angular == 0.0:
		sonido_rotacion.play(true)

	cuadro_optica.global_rotation = 0

func _on_area_de_interaccion_body_entered(body: Node2D) -> void:
	if body is Player:
		player_dentro_del_area = true


func _on_area_de_interaccion_body_exited(body: Node2D) -> void:
	if body is Player:
		player_dentro_del_area = false

func aplicar_velocidad_angular(delta):
	rotation += velocidad_angular * delta
	velocidad_angular = move_toward(velocidad_angular, 0.0, damping * delta)
