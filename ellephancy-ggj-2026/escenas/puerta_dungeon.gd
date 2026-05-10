class_name PuertaDungeon
extends Interactivo

@onready var area_2d: Area2D = $Area2D
var player_en_puerta : bool = false
var puerta_abierta : bool = false
var player : Player
@export var posicion_tp : Marker2D

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interactuar") and puerta_abierta:
		Global.teletransportar(player, posicion_tp.global_position)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_en_puerta = true
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_en_puerta = false
