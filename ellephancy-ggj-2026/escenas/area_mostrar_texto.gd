extends Area2D

@onready var label_texto: Label = %LabelTexto
@export var texto_encima : String
@onready var animation_player_texto: AnimationPlayer = %AnimationPlayerTexto


func _ready() -> void:
	label_texto.hide()
	label_texto.text = texto_encima



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		animation_player_texto.play("mostrar")
		label_texto.show()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		label_texto.hide()
