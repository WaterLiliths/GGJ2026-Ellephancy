extends Area2D

@onready var label_texto: Label = %LabelTexto
@export var texto_encima : String = ""
@onready var animation_player_texto: AnimationPlayer = %AnimationPlayerTexto
@onready var runa_teclas: Sprite2D = %RunaTeclas
@export var textura_runa_tecla : Texture

func _ready() -> void:
	runa_teclas.texture = textura_runa_tecla
#	label_texto.hide()
	label_texto.modulate.a = 0
	label_texto.text = texto_encima



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		#animation_player_texto.play("mostrar")
		#label_texto.show()
		tween_entrada()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		#label_texto.hide()
		#animation_player_texto.play("esconder_runass")
		tween_salida()


func tween_entrada():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(label_texto,"modulate:a", 1.0, 0.45)

func tween_salida():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(label_texto,"modulate:a", 0.0 , 0.7)
