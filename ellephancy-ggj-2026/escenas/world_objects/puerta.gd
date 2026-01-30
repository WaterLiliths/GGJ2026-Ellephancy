extends StaticBody2D

@export var id_puerta : int = 0
@export var varias_palancas : bool = false
@export_range(1,3,1) var cant_palancas : int = 1

@export var empieza_abierta : bool = false
@export var timeada : bool = false
@export var timer : float = 1.0

var contador_id : int = 0
@export var altura_maxima : float = 250.0
@export var tiempo_de_apertura : float = 1.5
@export var tamano = Vector2(1, 1)
@onready var sprite_2d: Sprite2D = %Sprite2D



var posicion_original = position.y
var esta_abierta = false
var fue_abierta = false

func _ready() -> void:
	%Sprite2D.scale = 3 * tamano
	$CollisionShape2D.scale = tamano
	if empieza_abierta:
		esta_abierta = true
		$Sprite2D.position.y = -altura_maxima
		$CollisionShape2D.position.y = -altura_maxima
	else:
		esta_abierta = false
	Global.activar_palanca.connect(cambiar_estado_puerta_abierta)
	Global.desactivar_palanca.connect(cambiar_estado_puerta_cerrada)
	$TimerTiempoDeApertura.set_wait_time(tiempo_de_apertura)
	$TimerPuerta.set_wait_time(timer)
	
	
#------------------FUNCIONES-----------------------
func cambiar_estado_puerta_abierta(id_palanca : int):
	if id_palanca == id_puerta and empieza_abierta:
		cerrar_puerta()
		return
	elif id_palanca != id_puerta or esta_abierta:
		#print("no se abre")
		return
	elif !varias_palancas and !esta_abierta:
		abrir_puerta()
		return
	if varias_palancas:
		contador_id += 1
		#print(contador_id)
		if contador_id != cant_palancas:
			return
		abrir_puerta()

func cambiar_estado_puerta_cerrada(id_palanca : int):
	if id_palanca != id_puerta:
		return
	contador_id -= 1
	if id_palanca == id_puerta and not esta_abierta and empieza_abierta:
		#print(contador_id)
		abrir_puerta()
	if id_palanca == id_puerta and esta_abierta and not empieza_abierta:
		#print(contador_id)
		cerrar_puerta()


func abrir_puerta():
	var tween_sprite = get_tree().create_tween()
	var tween_colision = get_tree().create_tween()
	tween_sprite.tween_property($Sprite2D, "position:y" , -altura_maxima, tiempo_de_apertura)
	tween_colision.tween_property($CollisionShape2D, "position:y" , -altura_maxima, tiempo_de_apertura)
	esta_abierta = true
	$TimerTiempoDeApertura.start()
	#print("la puerta esta abierta")
	$FmodEventEmitter2D.set_parameter("peso", 5.0)
	$FmodEventEmitter2D.play()

func cerrar_puerta():
	var tween_sprite = get_tree().create_tween()
	var tween_colision = get_tree().create_tween()
	tween_sprite.tween_property($Sprite2D, "position:y" , posicion_original, tiempo_de_apertura)
	tween_colision.tween_property($CollisionShape2D, "position:y" , posicion_original, tiempo_de_apertura)
	$TimerTiempoDeApertura.start()
	esta_abierta = false
	$FmodEventEmitter2D.set_parameter("peso", 5.0)
	$FmodEventEmitter2D.play()


func _on_timer_tiempo_de_apertura_timeout() -> void:
	$FmodEventEmitter2D2.play()
	$FmodEventEmitter2D.stop()
	if timeada and esta_abierta:
		$TimerPuerta.start()

func _on_timer_puerta_timeout() -> void:
	if timeada:
		$TimerPuerta.stop()
		if esta_abierta:
			cerrar_puerta()
		else:
			abrir_puerta()
			
