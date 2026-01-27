class_name ObjetoEmpujable 
extends RigidBody2D

var es_arrastrada : bool = false
var arrastra : Node2D = null

func _physics_process(delta: float) -> void:
#	pass
	if es_arrastrada and arrastra:
		global_position = arrastra.global_position

#-----------------FUNCIONES--------------
func empezar_arrastrar(marker : Node2D):
	es_arrastrada = true
	arrastra = marker
	freeze = true

func dejar_arrastrar():
	es_arrastrada = false
	arrastra = null
	freeze = false
