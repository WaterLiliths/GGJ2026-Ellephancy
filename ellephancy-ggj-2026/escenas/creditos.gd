extends Control

@export var volumen_maximo : float = 1


func _ready() -> void:
	$FmodEventEmitter2D.play()
	$FmodEventEmitter2D.volume = 0.0
	$ColorRect2.visible = true
	$AnimationPlayer.play("fade_in")
	var tween_audio = create_tween()
	tween_audio.tween_property($FmodEventEmitter2D, "volume", volumen_maximo, 8).set_trans(Tween.TRANS_SINE)


func _physics_process(delta: float) -> void:
	$RichTextLabel.position.y -= 40 * delta


func _on_boton_custom_pressed() -> void:
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(3.5).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://escenas/main_menu.tscn")
