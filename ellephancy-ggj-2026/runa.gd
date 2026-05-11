class_name Runa
extends TextureRect

@export var distancia_maxima_shader : float = 3000
var shader_material : ShaderMaterial

enum TiposDeRunas { NUDO_SIMETRICO, NUDO_ASIMETRICO, TRIQUETRA, CRUZ, TRISKELE, ATOMO }
var texturas_de_runas := {
		TiposDeRunas.NUDO_SIMETRICO: preload("res://assets/runas-finales/nudo_simetrico_blanco.png"),
		TiposDeRunas.NUDO_ASIMETRICO: preload("res://assets/runas-finales/nudo_asimetrico_blanco.png"),
		TiposDeRunas.TRIQUETRA: preload("res://assets/runas-finales/triquetra_blanco.png"),
		TiposDeRunas.CRUZ: preload("res://assets/runas-finales/cruz_blanco.png"),
		TiposDeRunas.TRISKELE: preload("res://assets/runas-finales/triskele_blanco.png"),
		TiposDeRunas.ATOMO: preload("res://assets/runas-finales/atomo_blanco.png"),
	}
	
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var point_light_2d: PointLight2D = $SubViewportContainer/Node2D/PointLight2D
@export var tipo_de_runa : TiposDeRunas

func _ready() -> void:
	hide()
	Global.mascara_traducciones_activa.connect(mostrar_runas)
	Global.mascara_traducciones_desactivar.connect(esconder_runas)
	animation_player.play("pulsar")

	shader_material = material.duplicate()
	material = shader_material
	shader_material.set_shader_parameter("rune_world_position", global_position)

func asignar_tipo(tipo : TiposDeRunas, color : Color):
	tipo_de_runa = tipo
	name = TiposDeRunas.keys()[tipo]
	texture = texturas_de_runas[tipo]
	expand_mode = TextureRect.EXPAND_FIT_HEIGHT
	modulate = color
	point_light_2d.color = color
	
	await get_tree().process_frame

func mostrar_runas():
	if global_position.distance_to(Global.get_player_position()) > distancia_maxima_shader:
		show() #en realidad hacer que la mascara ejecute el shader y mientras el shader esta activo le vaya pidiendo a todas las runas
		#seguramente llamando a un grupo que se vayan mostrando en funcion de la distancia de player y distancia del radio
		#osea el shader va a ir aumentando un radio, un valor, que van a leer las runas y segun eso activarse o desactivarse
	else:
		#aca iria el usar shader
		pass
	show() #por ahora dejo este siempre

func esconder_runas():
	hide()
