extends Area2D

@export var dialogo = preload("res://dialogue/primer_dialogo_salmon.dialogue")

var player_cerca : bool = false

func _ready() -> void:
	DialogueManager.dialogue_started.connect(on_dialogue_started)
	DialogueManager.dialogue_ended.connect(on_dialogue_ended)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interactuar") and player_cerca:
		tomar_mascara()

#-------------FUNCIONES--------------
func tomar_mascara():
	Global.tiene_mascara_traducciones = true
	Global.agarre_mascara.emit("salmon")
	DialogueManager.show_dialogue_balloon(dialogo, "start")
	print("AGARRE MASCARA")
	queue_free()

func on_dialogue_started(dialogue):
	pass


func on_dialogue_ended(dialogue):
	pass

#-------------SEÑALES---------------
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_cerca = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_cerca = false
