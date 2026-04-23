@tool
class_name BaseLente
extends RigidBody2D

@export_enum("LENTE", "ESPEJO") var tipo_de_optica : int = 0
@export var fijo : bool = false
@export var optica_rotable : bool = true
@export var rotacion_inicial : int = 0
@export var emisor : bool = false
var ultima_posicion : Vector2

const LENTE = preload("uid://ddadtanp2707x")
const ESPEJO = preload("uid://dg6y4xunbnxvq")

var optica

func _ready() -> void:
	collision_layer = 0
	if fijo:
		freeze = true
	match tipo_de_optica:
		0:
			var lente = LENTE.instantiate()
			optica = lente
			if emisor == true:
				optica.iniciador = true
			add_child(lente)
		1:
			var espejo = ESPEJO.instantiate()
			add_child(espejo)
			optica = espejo
	if not optica_rotable:
		optica.es_rotable = false
	optica.position += Vector2.UP * 32
	optica.rotation_degrees = -rotacion_inicial


#se llaman en global con get_tree().call_group("persistente", "guardar") y para cargar igual
func guardar():
	ultima_posicion = global_position
	#print("##### Objeto guardado con la key: ", get_path())
	Global.diccionario_persistentes[get_path()] = ultima_posicion #justo en este caso no necesito guardar mas info que la posicion
	#pero en los otros objetos podemos guardar mas cosas en un diccionario adentro de otro

#INFO usa el mismo save/load q objeto empujable asiq si a este nodo le ponemos un empujable vamos a tener q sacar el save-load de aca :D
func cargar(): 
#	print("-- se ejecuto cargar en el objeto empujable  : ", get_path())
	if Global.diccionario_persistentes.has(get_path()):
		#print("-------  ENCONTRE MI KEY EN EL DICCIONARIOOOOO ")
		ultima_posicion = Global.diccionario_persistentes[get_path()] #directamente pido lo q tenia guardado en esa key pq solo guardamos la posicion
		global_position = ultima_posicion
	else:
		guardar() #si por algun motivo no se habia guardado anteriormente, lo guardo con la posicion actual
	#	print("ATENCION ----- NO SE ENCONTRO MI INFO EN EL DICCIONARIO ")
