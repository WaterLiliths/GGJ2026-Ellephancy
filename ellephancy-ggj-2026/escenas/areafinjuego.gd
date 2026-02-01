extends Area2D

var escena_final : PackedScene = preload("res://escenas/finjuegoaaaaqueemocion.tscn")


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		terminar_juego_omg_voy_a_llorar()


func terminar_juego_omg_voy_a_llorar():
	print("omg")
	%AnimationPlayerFIN.play("fadefinall")


func _on_animation_player_fin_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadefinall":
		await get_tree().process_frame
		get_tree().change_scene_to_packed(escena_final)
