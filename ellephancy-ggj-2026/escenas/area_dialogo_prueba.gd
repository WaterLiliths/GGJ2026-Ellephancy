extends Area2D

@export var dialogo = preload("res://dialogue/dialogo_prueba.dialogue")

var player_cerca : bool = false
var dialogo_activo : bool = false
var dialogo_leido : bool = false


func _ready() -> void:
	DialogueManager.dialogue_started.connect(on_dialogue_started)
	DialogueManager.dialogue_ended.connect(on_dialogue_ended)

func on_dialogue_started(dialogue):
	dialogo_activo = true

func on_dialogue_ended(dialogue):
	dialogo_leido = true

func _on_body_entered(body: Node2D) -> void:
	if dialogo_leido:
		return
	if body is Player and !dialogo_activo:
		DialogueManager.show_dialogue_balloon(dialogo, "start")
