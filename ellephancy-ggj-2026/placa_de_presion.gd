extends Node2D


@onready var animated_sprite : AnimatedSprite2D = %AnimatedSprite2D
@export var tiempo_de_activacion : float = 1.2
var activo : bool = false
var contador_pisando : int = 0
var tiempo_body_entered : float = 0


func _physics_process(delta: float) -> void:
	if contador_pisando > 0: #hay al menos 1 body pisando la placa
		tiempo_body_entered += delta #empiezp a sumarle tiempo
		if tiempo_body_entered > tiempo_de_activacion and not activo:
			set_activo(true)
	else:
		tiempo_body_entered = 0



func _on_area_detectar_body_entered(body: Node2D) -> void:
	if body is Player or body is Empujable:
		contador_pisando += 1


func _on_area_detectar_body_exited(body: Node2D) -> void:
	if body is Player or body is Empujable:
		contador_pisando -= 1
		if activo == true and contador_pisando == 0:
			#print("estaba activo, desactivar")
			set_activo(false)


func set_activo(estado : bool):
	activo = estado
	if activo:
		#print("se activo la placa de presion")
		animated_sprite.play("activar")
		%FmodActivarPlaca.play() #placeholder, dsp lo cambiamos :D
		Global.activar_mecanismo.emit(self)
	else:
		animated_sprite.play("desactivar")
		Global.desactivar_mecanismo.emit(self)
