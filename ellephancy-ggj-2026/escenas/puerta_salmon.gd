extends StaticBody2D


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


func verificar_contrasena(contra1 : int, contra2 : int, contra3 : int):
	if contra1 == contrasena_1 and contra2 == contrasena_2 and contra3 == contrasena_3: #que feo codigo perdon jdasja
		abrir_puerta()
	else:
		print("se recibio la funcion, todavia la contraseña no coincide")


func abrir_puerta():
	print("ABRIR PUERTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	%AnimationPlayerSalmon.play("abrir_puerta")
