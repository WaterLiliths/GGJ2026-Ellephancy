extends StaticBody2D

@export var id_puerta : int = 0
@export var horizontal : bool = false
@export var varias_palancas : bool = false
@export_range(1,3,1) var cant_palancas : int = 1

@export var usa_runas : bool = false
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

var palancas : Array[Palanca] = []
var palancas_con_runas
var cantidad_de_runas : int = 0
enum TiposDeRunas { NUDO_SIMETRICO, NUDO_ASIMETRICO, TRIQUETRA, CRUZ, TRISKELE, ATOMO }
@onready var contenedor_de_runas: VBoxContainer = %Control/ContenedorDeRunas
var runas_correctas = {}
var runas_activadas = {}
const RUNA = preload("uid://bvq5bbgfqxbf3")




func _ready() -> void:
	if usa_runas:
		setup_runas()

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


func _process(_delta: float) -> void:
	$FmodEventEmitter2D.volume = Global.volumen_efectos
	$FmodEventEmitter2D2.volume = Global.volumen_efectos
	
#------------------FUNCIONES-----------------------
func cambiar_estado_puerta_abierta(id_palanca : int):
	if not usa_runas:
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
	if not usa_runas:
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
	if horizontal:
		tween_sprite.tween_property($Sprite2D, "position:x" , -altura_maxima, tiempo_de_apertura)
		tween_colision.tween_property($CollisionShape2D, "position:x" , -altura_maxima, tiempo_de_apertura)
	else:
		tween_sprite.tween_property($Sprite2D, "position:y" , -altura_maxima, tiempo_de_apertura)
		tween_colision.tween_property($CollisionShape2D, "position:y" , -altura_maxima, tiempo_de_apertura)
	esta_abierta = true
	Global.puerta_abierta.emit(global_position, tiempo_de_apertura)
	var conexiones = Global.get_signal_connection_list("puerta_abierta")
	for conectadas in conexiones:
		print("-------------- LA SEÑAL DE LA PUERTA ESTA CONECTADA AAAAAAAAAAAAAA -----------  ", conectadas["callable"])
	
	$TimerTiempoDeApertura.start()
	#print("la puerta esta abierta")
	$FmodEventEmitter2D.set_parameter("peso", 5.0)
	$FmodEventEmitter2D.play()

func cerrar_puerta():
	var tween_sprite = get_tree().create_tween()
	var tween_colision = get_tree().create_tween()
	if horizontal:
		tween_sprite.tween_property($Sprite2D, "position:x" , posicion_original, tiempo_de_apertura)
		tween_colision.tween_property($CollisionShape2D, "position:x" , posicion_original, tiempo_de_apertura)
	else:
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
			

func setup_runas():
	var tipos_disponibles = Runa.TiposDeRunas.values()
	var colores = [Color.RED, Color.MAGENTA, Color.YELLOW, Color.ORANGE, Color.CYAN, Color.GREEN]
	tipos_disponibles.shuffle()
	colores.shuffle()
	var index = 0
	for child in get_children():
		if child is Palanca:
			var palanca = child
			palancas.append(palanca)
			palanca.palanca_con_runa_activada.connect(_on_palanca_con_runa_activada)
			var runa_puerta = RUNA.instantiate()
			contenedor_de_runas.add_child(runa_puerta)
			var tipo = tipos_disponibles[index]
			var color = colores[index]
			index += 1
			runa_puerta.asignar_tipo(tipo, color)
			palanca.color = color
			
			#runa_puerta.modulate = color
			#palanca.runa.modulate = color
			
			runas_correctas[tipo] = palanca

func _on_palanca_con_runa_activada(palanca: Palanca, id_palanca, runa: Runa):
	if id_palanca == id_puerta:
		var tipo = runa.tipo_de_runa
		for key in runas_activadas.keys():
			if runas_activadas[key] == palanca:
				runas_activadas.erase(key)
				break
		if runas_correctas.has(tipo) and runas_correctas[tipo] == palanca:
			if not runas_activadas.has(tipo):
				runas_activadas[tipo] = palanca
				if runas_activadas.keys().size() == runas_correctas.keys().size():
					$FmodEventEmitter2D3.play()
					abrir_puerta()
