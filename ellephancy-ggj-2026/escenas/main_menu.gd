extends Control


func _ready() -> void:
	$FmodEventEmitter2D.set_parameter("Pantalla", "Menu")
	$ColorRect2.visible = false


func _on_boton_custom_comenzar_pressed() -> void:
	$FmodEventEmitter2D2.play()
	$ColorRect2.visible = true
	var tween = create_tween()
	tween.tween_property($ColorRect2, "color", Color(0,0,0,1), 1.5)
	tween.tween_property($FmodEventEmitter2D, "volume", 0.0, 1.5)
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://escenas/levels/first_level.tscn")
