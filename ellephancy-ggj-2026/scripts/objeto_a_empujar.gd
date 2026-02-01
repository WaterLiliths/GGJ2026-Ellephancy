extends RigidBody2D

@export var presente : bool
var densidad = 1
@onready var area
@onready var colision : CollisionShape2D = %CollisionShape2D
@onready var ultima_posicion : Vector2
var estaba_en_el_piso : bool = false
var esta_en_el_aire = false

func _ready() -> void:
	if not colision:
		var nodo_colision
		nodo_colision = get_tree().get_first_node_in_group("colision_cajas")
		if nodo_colision:
			colision = nodo_colision
	ultima_posicion = global_position
	Global.mascara_tiempo_activa.connect(on_mascara_tiempo_activa)
	Global.mascara_tiempo_desactivar.connect(on_mascara_tiempo_desactivada)
	if not presente:
		esconder_mundo()
	
	area = colision.global_scale.x * colision.global_scale.y
	mass = 1 + (densidad * area)
	print(area)
	print("la masa de esta piedra es " + str(mass))
	#esta_en_el_aire = $RayCast2D.is_colliding()


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



#func _physics_process(_delta: float) -> void:
	#if velocity.y == 0
		#$FmodEventEmitter2D2.play_one_shot()
	##var esta_en_el_piso = %RayCastAbajo.is_colliding()
	##detectar_caida()
	

#func detectar_caida():
	#if esta_en_el_aire and $RayCast2D.is_colliding():
		#$FmodEventEmitter2D.play_one_shot()
