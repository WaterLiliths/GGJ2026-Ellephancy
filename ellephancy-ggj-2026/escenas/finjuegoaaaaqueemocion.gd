extends Area2D


@onready var canvas_layer: CanvasLayer = %CanvasLayer
var creditos : PackedScene = preload("res://escenas/creditos.tscn")
var mostrar_creditos : bool = false


func _physics_process(delta: float) -> void:
	if mostrar_creditos:
		%RichTextLabel.position.y -= 40 * delta




func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		terminar_juego_omg_voy_a_llorar()


func terminar_juego_omg_voy_a_llorar():
	%Camera2D.make_current()
	print("omg")


func _on_animation_player_final_animation_finished(anim_name: StringName) -> void:
	if anim_name == "finjuego":
		#var instancia = creditos.instantiate()
		#canvas_layer.add_child(instancia)
		mostrar_creditos = true
