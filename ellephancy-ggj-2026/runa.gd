class_name Runa
extends TextureRect

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
	animation_player.play("pulsar")

func asignar_tipo(tipo : TiposDeRunas, color : Color):
	tipo_de_runa = tipo
	name = TiposDeRunas.keys()[tipo]
	texture = texturas_de_runas[tipo]
	expand_mode = TextureRect.EXPAND_FIT_HEIGHT
	modulate = color
	point_light_2d.color = color
	await get_tree().process_frame
