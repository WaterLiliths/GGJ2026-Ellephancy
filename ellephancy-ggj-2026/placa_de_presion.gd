extends Node2D


@onready var animated_sprite : AnimatedSprite2D = %AnimatedSprite2D
@export var tiempo_de_activacion : float = 1.5
var activo : bool = false
var body_adentro : bool = false
var tiempo_body_entered : float = 0


func _physics_process(delta: float) -> void:
	if body_adentro:
		tiempo_body_entered += delta
		if tiempo_body_entered > tiempo_de_activacion and not activo:
			set_activo(true)
	else:
		tiempo_body_entered = 0



func _on_area_detectar_body_entered(body: Node2D) -> void:
	if body is Player or body is Empujable:
		animated_sprite.play("activar")
		body_adentro = true


func _on_area_detectar_body_exited(body: Node2D) -> void:
	if body is Player or body is Empujable:
		animated_sprite.play("desactivar")
		body_adentro = false
		set_activo(false)


func set_activo(estado : bool):
	activo = estado
	if activo:
		print("se activo la placa de presion")
		%FmodActivarPlaca.play() #placeholder, dsp lo cambiamos :D
		Global.activar_mecanismo.emit(self)
	else:
		Global.desactivar_mecanismo.emit(self)
