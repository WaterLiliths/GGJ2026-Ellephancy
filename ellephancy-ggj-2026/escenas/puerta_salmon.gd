extends StaticBody2D


#-------------
@export var horizontal : bool = false
@export var timeada : bool = false
@export var timer : float = 1.0
@onready var portal_1: Node2D = %Portal1
@onready var portal_2: Node2D = %Portal2
@onready var portal_3: Node2D = %Portal_3


var contador_id : int = 0
@export var altura_maxima : float = 250.0
@export var tiempo_de_apertura : float = 1.5
@export var tamano = Vector2(1, 1)
@onready var sprite_2d: Sprite2D = %Sprite2D
#-----------

@export_range(1,6) var contrasena_1 : int = 1
@export_range(1,6) var contrasena_2 : int = 1
@export_range(1,6) var contrasena_3 : int = 1
@onready var controlador_runas: Node2D = %PuzzleSalmon1
@onready var runa_puerta_1: Sprite2D = %RunaPuerta1
@onready var runa_puerta_2: Sprite2D = %RunaPuerta2
@onready var runa_puerta_3: Sprite2D = %RunaPuerta3

var puerta_abierta : bool =false


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	runa_puerta_1.texture = controlador_runas.diccionario_runas[contrasena_1]
	runa_puerta_2.texture = controlador_runas.diccionario_runas[contrasena_2]
	runa_puerta_3.texture = controlador_runas.diccionario_runas[contrasena_3]
	portal_1.hide()
	portal_2.hide()
	portal_3.hide()


func verificar_contrasena(contra1 : int, contra2 : int, contra3 : int):
	if contra1 == contrasena_1:
		portal_1.show()
	else:
		portal_1.hide()
	if contra2 == contrasena_2:
		portal_2.show()
	else:
		portal_2.hide()
	if contra3 == contrasena_3:
		portal_3.show()
	else:
		portal_3.hide()
	if contra1 == contrasena_1 and contra2 == contrasena_2 and contra3 == contrasena_3: #que feo codigo perdon jdasja
		abrir_puerta()
	else:
		print("se recibio la funcion, todavia la contraseña no coincide")

#
#func abrir_puerta():
	#print("ABRIR PUERTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	#%AnimationPlayerSalmon.play("abrir_puerta")




func abrir_puerta():
	var tween_sprite = get_tree().create_tween()
	var tween_colision = get_tree().create_tween()
	if horizontal:
		tween_sprite.tween_property($Sprite2D, "position:x" , -altura_maxima, tiempo_de_apertura)
		tween_colision.tween_property($CollisionShape2D, "position:x" , -altura_maxima, tiempo_de_apertura)
	else:
		tween_sprite.tween_property($Sprite2D, "position:y" , -altura_maxima, tiempo_de_apertura)
		tween_colision.tween_property($CollisionShape2D, "position:y" , -altura_maxima, tiempo_de_apertura)
	$TimerTiempoDeApertura.start()
	#print("la puerta esta abierta")
	$FmodEventEmitter2D.set_parameter("peso", 5.0)
	$FmodEventEmitter2D.play()
