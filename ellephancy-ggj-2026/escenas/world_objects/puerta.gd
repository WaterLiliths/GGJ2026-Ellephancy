extends StaticBody2D

@export var id_puerta : int = 0
@export var varias_palancas : bool = false
@export_range(1,3,1) var cant_palancas : int = 1

var contador_id : int = 0
@export var altura_maxima : float = 250.0
@export var tiempo_de_apertura : float = 1.5

var esta_abierta = false
var fue_abierta = false

func _ready() -> void:
	esta_abierta = false
	Global.activar_palanca.connect(cambiar_estado_puerta_abierta)
	Global.desactivar_palanca.connect(cambiar_estado_puerta_cerrada)
	$TimerPuerta.set_wait_time(tiempo_de_apertura)
	
#------------------FUNCIONES-----------------------
func cambiar_estado_puerta_abierta(id_palanca : int):
	if id_palanca != id_puerta or esta_abierta:
		print("no se abre")
		return
	if !varias_palancas and !esta_abierta:
		abrir_puerta()
		return
	if varias_palancas:
		contador_id += 1
		print(contador_id)
		if contador_id != cant_palancas:
			return
		abrir_puerta()

func cambiar_estado_puerta_cerrada(id_palanca : int):
	if id_palanca != id_puerta:
		return
	contador_id -= 1
	if id_palanca == id_puerta and esta_abierta:
		print(contador_id)
		cerrar_puerta()


func abrir_puerta():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "position:y" , -altura_maxima, tiempo_de_apertura)
	tween.tween_property($CollisionShape2D, "position:y" , -altura_maxima, tiempo_de_apertura)
	esta_abierta = true
	$TimerPuerta.start()
	print("la puerta esta abierta")
	#%AnimationPuerta.play("abir_sprite")
	$FmodEventEmitter2D.set_parameter("peso", 5.0)
	$FmodEventEmitter2D.play()

func cerrar_puerta():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "position:y" , 0, tiempo_de_apertura)
	$TimerPuerta.start()
	esta_abierta = false
	print("la puerta esta cerrada")
	#%AnimationPuerta.play("cerrar_puerta")
	$FmodEventEmitter2D.set_parameter("peso", 5.0)
	$FmodEventEmitter2D.play()


#func _on_animation_puerta_animation_finished(_anim_name: StringName) -> void:
	#$FmodEventEmitter2D2.play()
	#$FmodEventEmitter2D.stop()


func _on_timer_puerta_timeout() -> void:
	$FmodEventEmitter2D2.play()
	$FmodEventEmitter2D.stop()
