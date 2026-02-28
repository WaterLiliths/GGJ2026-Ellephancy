class_name Empujable
extends CharacterBody2D

@export var presente : bool
@onready var ultima_posicion : Vector2
@onready var colision : CollisionShape2D = %CollisionShape2D
var direccion : int = 0
var velocidad : float = 0.0
var siendo_agarrada : bool = false
@onready var impacto: FmodEventEmitter2D = $Impacto
var sonido_caja_sonando = false
#@onready var area_trampa: AreaTrampa = %AreaTrampa



func _ready() -> void:
	impacto.set_parameter("peso", 5.0)
	ultima_posicion = global_position
	Global.mascara_tiempo_activa.connect(on_mascara_tiempo_activa)
	Global.mascara_tiempo_desactivar.connect(on_mascara_tiempo_desactivada)
	if not presente:
		esconder_mundo()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		#area_trampa.monitoring = true
		velocity += get_gravity() * delta
		if velocity.y > 0:
			impacto.play()
	if siendo_agarrada:
		#print("la caja esta siendo agarrada -------------++++++++++++++-----+-+++++++++++++++++++++++++")
		velocity.x = direccion * velocidad
	else:
		velocity.x = move_toward(velocity.x, 0, 800 * delta)
		#area_trampa.monitoring = false 
	move_and_slide()

#-------------FUNCIONES-------------
func on_mascara_tiempo_activa():
	if presente:
		ultima_posicion = global_position
		esconder_mundo()
	else:
		mostrar_mundo()


func on_mascara_tiempo_desactivada():
	if presente:
		mostrar_mundo() #hago lo contrario nada mas
		#codigo unga unga pero anda 
	else:
		esconder_mundo()

func esconder_mundo():
	colision.set_deferred("disabled", true)
	hide()


func mostrar_mundo():
	global_position = ultima_posicion
	colision.set_deferred("disabled", false)
	show()


func agarrar(direccion_player : float, velocidad_player : float):
	direccion = direccion_player
	velocidad = velocidad_player
	siendo_agarrada = true


func soltar():
	direccion = 0
	velocidad = 0
	siendo_agarrada = false
