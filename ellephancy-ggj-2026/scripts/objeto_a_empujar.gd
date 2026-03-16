@icon("res://assets/iconos/Empujable.svg") #el icono ya venia con godot (en el repo oficial), es un detallito nomas
class_name Empujable
##NODO EMPUJABLE : para usarlo solamente tenemos que agregarle collision shape y un sprite, en caso de que queramos que cualquier otro objeto sea empujable podemos hacer de este su nodo padre
extends CharacterBody2D

@export var presente : bool = true
##El peso lo usamos para pasarle este valor a FMOD y que suene distinto. Ademas de que podriamos hacer que player empuje este objeto con una velocidad acorde al peso (más pesado = más lento)

@export_range(1.0, 10.0) var peso : float = 5.0
@onready var ultima_posicion : Vector2
var colision : CollisionShape2D
var direccion : int = 0
var velocidad : float = 0.0
var aceleracion : float = 0.0
var siendo_agarrada : bool = false
@onready var impacto: FmodEventEmitter2D = %Impacto
var sonido_caja_sonando = false
@onready var fmod_arrastrar: FmodEventEmitter2D = %Arrastrar


func _ready() -> void:
	colision = buscar_colision_shape()
	impacto.set_parameter("peso", peso)
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
		#velocity.x = direccion * velocidad
		movimiento_horizontal(direccion, delta)
		if direccion!=0:
			ejecutar_sonido_arrastrar(peso)
		else:
			detener_sonido_arrastrar()
	else:
		velocity.x = move_toward(velocity.x, 0, 800 * delta)
		detener_sonido_arrastrar()
		#area_trampa.monitoring = false 
	move_and_slide()

#-------------FUNCIONES-------------
func on_mascara_tiempo_activa():
	if presente:
		ultima_posicion = global_position
		esconder_mundo()
	else:
		mostrar_mundo()

func buscar_colision_shape():
	for child in get_children():
		if child is CollisionShape2D:
			return child
	print("OJO no se encontro colision shape en un objeto empujable")
	return null

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


func agarrar(direccion_player : float, velocidad_player : float, aceleracion_player : float):
	direccion = direccion_player
	velocidad = velocidad_player
	aceleracion = aceleracion_player
	siendo_agarrada = true


func soltar():
	direccion = 0
	velocidad = 0
	aceleracion = 0
	siendo_agarrada = false


func movimiento_horizontal(direccion , delta  :float): #literal la misma funcion q tiene player, ahora la caja no se separa de player cuando hacemos a d a d rapido
	velocity.x = move_toward(velocity.x, direccion * velocidad, aceleracion * delta)


func ejecutar_sonido_arrastrar(peso : float):
	if sonido_caja_sonando:
		return
	fmod_arrastrar.set_parameter("peso", peso)
	fmod_arrastrar.play()
	sonido_caja_sonando = true

func detener_sonido_arrastrar():
	sonido_caja_sonando = false
	fmod_arrastrar.stop()

func cargar():
	print("-- se ejecuto cargar en el objeto empujable")
	#print("-- la ruta del objeto es : ", get_path()) #y aca no sabia como obtener el uid
