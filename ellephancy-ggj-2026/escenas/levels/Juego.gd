extends Node2D

@export var volumen_maximo : float = 0.1

func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	$FmodEventEmitter2D2.play()
	$AnimationPlayer.play("fade_in")


#Rezá Malena rezá
