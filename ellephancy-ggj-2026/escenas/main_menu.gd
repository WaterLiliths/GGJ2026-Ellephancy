extends Control


func _ready() -> void:
	$FmodEventEmitter2D.set_parameter("Pantalla", "Menu")
	$ColorRect2.visible = false


func _on_boton_custom_comenzar_pressed() -> void:
	$FmodEventEmitter2D2.play()
	$ColorRect2.visible = true
	var tween = create_tween()
	var tween_audio = create_tween()
	tween.tween_property($ColorRect2, "color", Color(0,0,0,1), 2)
	tween_audio.tween_property($FmodEventEmitter2D, "volume", 0.0, 1).set_trans(Tween.TRANS_LINEAR)
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://escenas/levels/juego.tscn")
