extends StaticBody2D

@export var id_puerta : int = 0
#@export var id_opcional : int = 0
@export var varias_palancas : bool = false
@export_range(1,3,1) var cant_palancas : int = 1

var contador_id : int = 0
@export var altura_maxima : float = 250.0
@export var tiempo_de_apertura : float = 1.5

var esta_abierta = false


func _ready() -> void:
	
	esta_abierta = false
	Global.usar_palanca.connect(cambiar_estado_puerta)
	$TimerPuerta.set_wait_time(tiempo_de_apertura)
	%AnimationPuerta.speed_scale = 1 / tiempo_de_apertura

func _process(_delta: float) -> void:
	pass
	
#------------------FUNCIONES-----------------------
func cambiar_estado_puerta(id_palanca : int):
	if id_palanca != id_puerta:
		print("palanca equivocada")
		return
#	if !varias_palancas and id_palanca == id_puerta:
#		%AnimationPuerta.play("abir_sprite")
#	elif varias_palancas:
#		contador_id += 1
#		if contador_id != cant_palancas:
#			return
#		%AnimationPuerta.play("abir_sprite")
	if esta_abierta:
		cerrar_puerta()
	else:
		abrir_puerta()

func abrir_puerta():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "position:y" , -altura_maxima, tiempo_de_apertura)
	esta_abierta = true
	$TimerPuerta.start()
	#print("la puerta esta abierta")
	#%AnimationPuerta.play("abir_sprite")
	$FmodEventEmitter2D.set_parameter("peso", 5.0)
	$FmodEventEmitter2D.play()

func cerrar_puerta():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "position:y" , 0, tiempo_de_apertura)
	$TimerPuerta.start()
	esta_abierta = false
	#print("la puerta esta cerrada")
	#%AnimationPuerta.play("cerrar_puerta")
	$FmodEventEmitter2D.set_parameter("peso", 5.0)
	$FmodEventEmitter2D.play()


#func _on_animation_puerta_animation_finished(_anim_name: StringName) -> void:
	#$FmodEventEmitter2D2.play()
	#$FmodEventEmitter2D.stop()


func _on_timer_puerta_timeout() -> void:
	$FmodEventEmitter2D2.play()
	$FmodEventEmitter2D.stop()
