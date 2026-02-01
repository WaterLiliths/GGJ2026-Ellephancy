extends StaticBody2D

@export var presente : bool
@onready var colision: CollisionPolygon2D = $CollisionPolygon2D

@onready var ultima_posicion : Vector2

func _ready() -> void:
	ultima_posicion = global_position
	Global.mascara_tiempo_activa.connect(on_mascara_tiempo_activa)
	Global.mascara_tiempo_desactivar.connect(on_mascara_tiempo_desactivada)
	if not presente:
		esconder_mundo()


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
