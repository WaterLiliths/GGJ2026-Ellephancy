class_name ChequeadorDeObjetivos
extends Node

const LUCIERNAGAS = preload("uid://bq06edhxvia6a")

@export var player : Player

func _ready() -> void: 
	pass
	#conectar señal de recibir input desde algun nodo de player

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ayuda"):
		var luciernaga = LUCIERNAGAS.instantiate()
		player.get_parent().add_child(luciernaga)
		luciernaga.movement_target = Objetivos.marker_luciernagas
		luciernaga.position = player.global_position
		print("player pide ayuda")
		print(Objetivos.objetivo_actual)
