extends Area2D


@onready var campanita_animada: AnimatedSprite2D = %CampanitaAnimada
##indicar que necesita agarrar una mascara para avanzar
@export_enum("oso", "ciervo", "salmon") var mascara_necesaria : String
var puede_pasar : bool = false

func _ready() -> void:
	tween_salida()

func _on_body_entered(body: Node2D) -> void:
	match mascara_necesaria:
		"oso":
			if Global.tiene_mascara_fuerza:
				puede_pasar = true
		"ciervo":
			if Global.tiene_mascara_tiempo:
				puede_pasar = true
		"salmon":
			if Global.tiene_mascara_traducciones:
				puede_pasar = true
	if puede_pasar:
		queue_free()
	else:
		tween_entrada()

func _on_body_exited(body: Node2D) -> void:
	if not puede_pasar:
		tween_salida()


func tween_entrada():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(campanita_animada,"modulate:a", 1.0, 0.45)

func tween_salida():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(campanita_animada,"modulate:a", 0.0 , 0.7)
