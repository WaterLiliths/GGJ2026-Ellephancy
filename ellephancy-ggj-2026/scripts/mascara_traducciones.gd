class_name MascaraSalmon
extends Node2D #mascara de las traducciones es 3

@export var id : int = 3
@export var activa : bool = false
@onready var nodo_shader: TextureRect = %TextureShader
var material_shader : ShaderMaterial

func _ready() -> void:
	activa = false
	material_shader = nodo_shader.material.duplicate() #primero lo duplico
	nodo_shader.material = material_shader #se le asigna el duplicado

func usar():
#	print("USAR EN LA MASCARA")
	if activa:
		return
	activa = true
	Global.mascara_activa = id
	Global.mascara_traducciones_activa.emit()
	nodo_shader.show()
	animacion_activar_shader(3)
#	print("-------- se uso la mascara de traducciones")


func desactivar():
	if not activa: #si ya estaba desactivada
		return
	activa = false
	Global.mascara_traducciones_desactivar.emit()
	actualizar_radio(0)
	nodo_shader.hide()


func animacion_activar_shader(duracion : float = 0.2):
	#para q la onda empiece en el mismo lugar q player
	RenderingServer.global_shader_parameter_set("player_position", Global.get_player_position())
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUART) # Una transición que empieza rápido y se frena
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_method(actualizar_radio, 0.0, 1000.0, duracion) #1000 es el radio, es un monton pero es de prueba

func actualizar_radio(valor_actual : float): #resulta q con un tween podemos llamar a una funcion, re loco
	RenderingServer.global_shader_parameter_set("radio_onda", valor_actual)
