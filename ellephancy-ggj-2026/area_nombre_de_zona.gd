extends Area2D

@export var nombre_de_zona: String = ""

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.mostrar_nombre_zona(nombre_de_zona)
