extends Node


func _ready() -> void:
	$FmodEventEmitter2D2.play()
	Global.cambiar_volumen.connect(_on_cambiar_volumen)


func _on_cambiar_volumen():
	$FmodEventEmitter2D2.volume = Global.volumen_musica
	$FmodEventEmitter2D.volume = Global.volumen_ambiente
