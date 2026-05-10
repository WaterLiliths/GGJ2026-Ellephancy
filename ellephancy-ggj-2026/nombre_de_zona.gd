extends Control

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var nombre_de_zona : String = "Nombre"

func _ready() -> void:
	rich_text_label.text = nombre_de_zona
	animation_player.play("animacion")
