extends Area2D

#LEE ESTOOOOOOOOOOOOOOOOOOOOOOOOOOOO
#ATENCION ATENCION COMPRAMOS CARROS Y CAMIONETAS !!!!
##si ponemos en cero no necesita ninguna mascara especifica (1- CIERVO, 2-OSO, 3-SALMON)
@export_range(0,3) var mascara_necesaria_para_ver : int = 0
@export var dialogo = preload("res://dialogue/primer_dialogo_oso.dialogue")
@export_range(1,20) var id_a_destruir : int
var player_cerca : bool = false
var dialogo_activo : bool = false
var dialogo_leido : bool = false
@export_range(1,20) var id_dialogo : int = 0

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
		Global.dialogo_desactivado_to_player.emit()
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	#if dialogo_leido:
		#return
	if mascara_necesaria_para_ver!=0 and Global.mascara_activa != mascara_necesaria_para_ver:
		print("pasaste por un dialogo, pero para verlo necesitas la mascara : ", mascara_necesaria_para_ver)
		return
	if body is Player and not dialogo_leido:
		print("EJECUTAR DIALOGOOOOOOOOOO")
		DialogueManager.show_dialogue_balloon(dialogo, "start")
		dialogo_leido = true
		Global.dialogo_activo_to_player.emit() #LO ESCUCHA PLAYER
