extends Node2D

func _ready() -> void:
	$FmodEventEmitter2D2.play()
	$FmodEventEmitter2D2.volume = 0.0
	$Player/Camera2D/Control/ColorRect.visible = true
	var tween = create_tween()
	var tween_audio = create_tween()
	tween_audio.tween_property($FmodEventEmitter2D2, "volume", 1.0, 5).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Player/Camera2D/Control/ColorRect, "color", Color(0,0,0,0), 5)
