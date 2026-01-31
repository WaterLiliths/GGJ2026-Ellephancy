extends Node2D

var tween = create_tween()

func _ready() -> void:
#	$Opciones.visible = false
	$FmodEventEmitter2D2.volume = 0.0
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	$FmodEventEmitter2D2.play()
	$AnimationPlayer.play("fade_in")
	tween.tween_property($FmodEventEmitter2D2, "volume", Global.volumen_musica, 4)
#Rezá Malena rezá

func _process(_delta: float) -> void:
	$FmodEventEmitter2D.volume = Global.volumen_musica
	$FmodEventEmitter2D2.volume = Global.volumen_ambiente
