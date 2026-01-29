extends Node2D


func _ready() -> void:
	$FmodEventEmitter2D2.set_parameter("Pantalla", "Juego")
	$FmodEventEmitter2D2.play()
