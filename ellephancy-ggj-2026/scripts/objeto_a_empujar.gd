extends RigidBody2D


func _ready() -> void:
	freeze = false


func _process(delta: float) -> void:
	pass

func tirar(posicion_jugador: Vector2):
	freeze = true
	
	var direccion : Vector2 = (posicion_jugador - global_position).normalized()

func soltar():
	freeze = false
