extends Area2D

@export var tutorial_id: String = ""
@export var imagenes: Array[Texture2D] = []
@export var textos: Array[String] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		TutorialManager.try_show(tutorial_id, imagenes, textos)
