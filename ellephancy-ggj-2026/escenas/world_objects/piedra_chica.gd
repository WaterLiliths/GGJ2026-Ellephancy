extends RigidBody2D

@export var presente : bool
var densidad = 1
@onready var area
@onready var colision = $CollisionShape2D
@onready var ultima_posicion : Vector2
var estaba_en_el_piso : bool = false
var esta_en_el_aire = false

func _ready() -> void:
	ultima_posicion = global_position
	Global.mascara_tiempo_activa.connect(on_mascara_tiempo_activa)
	Global.mascara_tiempo_desactivar.connect(on_mascara_tiempo_desactivada)
	if not presente:
		esconder_mundo()
	
	area = $CollisionShape2D.global_scale.x * $CollisionShape2D.global_scale.y
	mass = 1 + (densidad * area)
	print(area)
	print("la masa de esta piedra es " + str(mass))


#-------------FUNCIONES-------------
func on_mascara_tiempo_activa():
	if presente:
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
