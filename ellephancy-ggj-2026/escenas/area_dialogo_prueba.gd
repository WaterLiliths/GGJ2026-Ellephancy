extends Area2D

@export var dialogo = preload("res://dialogue/dialogo_prueba.dialogue")
@export_range(1,10) var id_a_destruir : int
var player_cerca : bool = false
var dialogo_activo : bool = false
var dialogo_leido : bool = false
@export_range(1,10) var id_dialogo : int = 0

func _ready() -> void:
	DialogueManager.dialogue_started.connect(on_dialogue_started)
	DialogueManager.dialogue_ended.connect(on_dialogue_ended)

func on_dialogue_started(dialogue):
	#dialogo_activo = true
	pass

func on_dialogue_ended(dialogue):
	#dialogo_leido = true
#	queue_free()
	if dialogo_leido and id_dialogo == id_a_destruir:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	#if dialogo_leido:
		#return
	if body is Player and not dialogo_leido:
		print("EJECUTAR DIALOGOOOOOOOOOO")
		DialogueManager.show_dialogue_balloon(dialogo, "start")
		dialogo_leido = true
