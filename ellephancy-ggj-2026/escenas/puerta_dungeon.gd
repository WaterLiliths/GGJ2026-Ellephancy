class_name PuertaDungeon
extends Interactivo

@onready var area_2d: Area2D = $Area2D
var player_en_puerta : bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_en_puerta = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_en_puerta = false
