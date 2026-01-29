class_name BotonCustom
extends Control



func _on_mouse_entered() -> void:
	$FmodEventEmitter2D.play()


func _on_pressed() -> void:
	$FmodEventEmitter2D2.play()
