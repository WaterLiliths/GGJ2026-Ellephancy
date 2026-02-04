extends Node2D

var mover_camara : bool = false

func _ready() -> void:
	Global.puerta_abierta.connect(mover_camara_a_puerta)

	
	
func _physics_process(_delta: float) -> void:
	if mover_camara:
		pass
	else:
		position = get_local_mouse_position() * 0.5
	

func mover_camara_a_puerta(global_position, tiempo_de_apertura):
	mover_camara = true
	var tween_camara = create_tween()
	tween_camara.tween_property(self, "global_position", global_position, 0.5).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(tiempo_de_apertura).timeout
	mover_camara = false
	
