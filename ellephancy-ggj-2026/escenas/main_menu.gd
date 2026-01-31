extends Control


func _ready() -> void:
	$FmodEventEmitter2D.set_parameter("Pantalla", "Menu")
	$ColorRect2.visible = true
	$ColorRect2.z_index = 3
	
	$ColorRect2.color = Color(0,0,0,1)
	$AnimationPlayer.play("titulo")
	await get_tree().create_timer(5).timeout
	$ColorRect2.visible = false
	$ColorRect2.z_index = 8


func _on_boton_custom_comenzar_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://escenas/levels/juego.tscn")


func _on_boton_custom_creditos_pressed() -> void:
	$FmodEventEmitter2D2.play()
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://escenas/creditos.tscn")
