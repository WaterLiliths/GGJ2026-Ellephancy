extends Node2D


@onready var animated_sprite : AnimatedSprite2D = %AnimatedSprite2D
@export var tiempo_de_activacion : float = 0.8
var activo : bool = false
var contador_pisando : int = 0
var tiempo_body_entered : float = 0


@export var se_activa_con_player : bool = false
@export var se_activa_con_empujable : bool = false


func _physics_process(delta: float) -> void:
	if contador_pisando > 0: #hay al menos 1 body pisando la placa
		tiempo_body_entered += delta #empiezp a sumarle tiempo
		if tiempo_body_entered > tiempo_de_activacion and not activo:
			set_activo(true)
			print("se activó la placa")
	else:
		tiempo_body_entered = 0



func _on_area_detectar_body_entered(body: Node2D) -> void:
	if body is Player and se_activa_con_player:
		contador_pisando += 1
	elif body is Empujable and se_activa_con_empujable:
		contador_pisando += 1
		#mi idea de meterle tiempo para activar es q aca pongamos un sonidito de pisando la placa


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
