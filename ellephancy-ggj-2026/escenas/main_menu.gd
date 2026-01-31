extends Control

func _ready() -> void:
	$Opciones.visible = false
	$FmodEventEmitter2D.volume = Global.volumen_musica
	$FmodEventEmitter2D2.volume = Global.volumen_efectos
	
	$FmodEventEmitter2D.set_parameter("Pantalla", "Menu")
	$ColorRect2.visible = true
	$ColorRect2.z_index = 3
	
	$ColorRect2.color = Color(0,0,0,1)
	$AnimationPlayer.play("titulo")
	$FmodEventEmitter2D4.play()
	await get_tree().create_timer(2.2).timeout
	$FmodEventEmitter2D3.play()
	await get_tree().create_timer(0.5).timeout
	$FmodEventEmitter2D.play()
	
func _process(_delta: float) -> void:
	$FmodEventEmitter2D.volume = Global.volumen_musica
	$FmodEventEmitter2D2.volume = Global.volumen_efectos

func _on_boton_custom_comenzar_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://escenas/levels/juego.tscn")

#
func _on_boton_custom_creditos_pressed() -> void:
	$FmodEventEmitter2D2.play()
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://escenas/creditos.tscn")
	


func _on_boton_custom_opciones_pressed() -> void:
	if $Opciones.visible:
		$Opciones.visible = false
	else:
		$Opciones.visible = true
