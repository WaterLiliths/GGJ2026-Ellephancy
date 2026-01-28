class_name ObjetoEmpujable 
extends RigidBody2D

var es_arrastrada : bool = false
var arrastra : Node2D = null
var player : Player = null 



	

func _physics_process(delta: float) -> void:

	if player == null:
		return
	
	
	
	#if es_arrastrada and arrastra:
		#global_position = arrastra.global_position
		
	

#-----------------FUNCIONES--------------
#func empezar_arrastrar(marker : Node2D):
##	freeze = true
	#es_arrastrada = true
	#arrastra = marker
	#freeze = true
#
#func dejar_arrastrar():
##	freeze = false
	#es_arrastrada = false
	#arrastra = null
	#freeze = false


#func _on_area_interaccion_body_entered(body: Node2D) -> void:
	#if player == null:
		#body = player
#
#
#func _on_area_interaccion_body_exited(body: Node2D) -> void:
	#if player == body:
		#player = null
