extends Node2D

func _ready() -> void:
	$FmodEventEmitter2D2.play()
	$Player/Camera2D/Control/ColorRect.visible = true
	var tween = create_tween()
	tween.tween_property($Player/Camera2D/Control/ColorRect, "color", Color(0,0,0,0), 3)
	#tween.tween_property($FmodEventEmitter2D2, "volume", 1.0, 3.0)
