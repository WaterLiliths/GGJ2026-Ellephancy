extends Area2D

@export var dialogo = preload("res://dialogue/primer_dialogo_ciervo.dialogue")
var player_cerca : bool = false
@onready var area_dialogo_prueba: Area2D = %AreaDialogoPrueba

func _ready() -> void:
	#area_dialogo_prueba.dialogue_ended.connect(termino_dialogo)
	area_dialogo_prueba.monitoring = false

func _ready() -> void:
	DialogueManager.dialogue_started.connect(on_dialogue_started)
	DialogueManager.dialogue_ended.connect(on_dialogue_ended)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interactuar") and player_cerca:
		tomar_mascara()

#-------------FUNCIONES--------------
func tomar_mascara():
	Global.tiene_mascara_tiempo = true
	Global.agarre_mascara.emit("ciervo")
	area_dialogo_prueba.forzar_lectura()



func on_dialogue_started(dialogue):
	pass


func on_dialogue_ended(dialogue):
	pass
#---------------SEÑALES--------------
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_cerca = true




func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_cerca = false


func termino_dialogo():
	print("termino el dialogo del CIERVO")
	Global.dialogo_desactivado_to_player.emit()
	queue_free()


func _on_area_dialogo_prueba_termino_lectura_forzada() -> void:
	termino_dialogo()
