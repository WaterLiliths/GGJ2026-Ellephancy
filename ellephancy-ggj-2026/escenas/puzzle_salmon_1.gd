extends Node2D


@export var runa_1 : Texture#todas las runas se las paso por editor
@export var runa_2 : Texture
@export var runa_3 : Texture
@export var runa_4 : Texture
@export var runa_5 : Texture
@export var runa_6 : Texture
@onready var runa_cambiante_1: Sprite2D = %RunaCambiante1 #refe a los nodos
@onready var runa_cambiante_2: Sprite2D = %RunaCambiante2
@onready var runa_cambiante_3: Sprite2D = %RunaCambiante3
@onready var puerta_salmon: StaticBody2D = %PuertaSalmon
@onready var contenedor_runas: Node2D = %ContenedorRunas
@onready var animation_player_runas: AnimationPlayer = %AnimationPlayerRunas
@onready var palanca_salmon_1: Area2D = %PalancaSalmon1
@onready var palanca_salmon_2: Area2D = %PalancaSalmon2
@onready var palanca_salmon_3: Area2D = %PalancaSalmon3


#si estas leyendo esto es porque el nene NO está bien

var contador_palanca_1_usada : int = 1#cada palanca cambia solamente a su runa (palanca 1 runa_cambiante 1)
var contador_palanca_2_usada : int = 1
var contador_palanca_3_usada : int = 1
@export_range(1,6) var runa_1_comienza_con : int = 1 #solo para setearlas desde codigo
@export_range(1,6) var runa_2_comienza_con : int = 1
@export_range(1,6) var runa_3_comienza_con : int = 1
var diccionario_runas : Dictionary = {}


func _ready() -> void:
	palanca_salmon_1.activar_cambiar_runa.connect(cambiar_runa)
	palanca_salmon_2.activar_cambiar_runa.connect(cambiar_runa)
	palanca_salmon_3.activar_cambiar_runa.connect(cambiar_runa)
	animation_player_runas.play("esconderr_runas_sueltas")
	Global.mascara_traducciones_activa.connect(mostrar_runas)
	Global.mascara_traducciones_desactivar.connect(esconder_runas)
	#seteo el diccionario
	diccionario_runas[1] = runa_1 #otro codigo unga unga pero bueno funca
	diccionario_runas[2] = runa_2
	diccionario_runas[3] = runa_3
	diccionario_runas[4] = runa_4
	diccionario_runas[5] = runa_5
	diccionario_runas[6] = runa_6
	contador_palanca_1_usada = runa_1_comienza_con
	contador_palanca_2_usada = runa_2_comienza_con
	contador_palanca_3_usada = runa_3_comienza_con
	#print("el diccionario vale: ", diccionario_runas)
	runa_cambiante_1.texture = diccionario_runas[runa_1_comienza_con] #le seteo la textura con la q comienza
	runa_cambiante_2.texture = diccionario_runas[runa_2_comienza_con]
	runa_cambiante_3.texture = diccionario_runas[runa_3_comienza_con]
	#print("probando, el valor del diccionario es: ", diccionario_runas[1])


func cambiar_runa(palanca_id : int):
	print("inicio de funcion, no el match, entra aca al menos????????????")
	match palanca_id:
		1:
			print("ENTRA ACA???????????")
			contador_palanca_1_usada = contador_palanca_1_usada + 1
			if contador_palanca_1_usada>6:
				contador_palanca_1_usada = 1 #reseteo
			runa_cambiante_1.texture = diccionario_runas[contador_palanca_1_usada]
			verificar_contrasena()
		2:
			contador_palanca_2_usada = contador_palanca_2_usada + 1
			if contador_palanca_2_usada>6:
				contador_palanca_2_usada = 1 #reseteo
			runa_cambiante_2.texture = diccionario_runas[contador_palanca_2_usada]
			verificar_contrasena()
		3:
			contador_palanca_3_usada = contador_palanca_3_usada + 1
			if contador_palanca_3_usada>6:
				contador_palanca_3_usada = 1 #reseteo
			runa_cambiante_3.texture = diccionario_runas[contador_palanca_3_usada]
			verificar_contrasena()


func _on_palanca_salmon_1_activar_cambiar_runa(id_palanca_int: int) -> void:
	#print("PALANCA USADA - se cambiara de runa")
	cambiar_runa(id_palanca_int)


func _on_palanca_salmon_2_activar_cambiar_runa(id_palanca_int: int) -> void:
	#print("PALANCA 2 USADA - se cambiara de runa")
	cambiar_runa(id_palanca_int)


func _on_palanca_salmon_3_activar_cambiar_runa(id_palanca_int: int) -> void:
	#print("PALANCA 3 USADAA  - se cambiara de runa")
	cambiar_runa(id_palanca_int)


func verificar_contrasena():
	puerta_salmon.verificar_contrasena(contador_palanca_1_usada, contador_palanca_2_usada, contador_palanca_3_usada)


func esconder_runas():
	contenedor_runas.hide()
	animation_player_runas.play("esconderr_runas_sueltas")


func mostrar_runas():
	contenedor_runas.show()
	animation_player_runas.play("mostrarr_runas_sueltas")
