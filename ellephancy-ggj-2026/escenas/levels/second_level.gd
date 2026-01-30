extends Node2D

@export var volumen_maximo : float = 0.1

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	$FmodEventEmitter2D2.play()
	$FmodEventEmitter2D2.volume = 0.0
	$Player/Camera2D/Control/ColorRect.visible = true
	var tween = create_tween()
	var tween_audio = create_tween()
	tween_audio.tween_property($FmodEventEmitter2D2, "volume", volumen_maximo, 5).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Player/Camera2D/Control/ColorRect, "color", Color(0,0,0,0), 5)

#Rezá Malena rezá
