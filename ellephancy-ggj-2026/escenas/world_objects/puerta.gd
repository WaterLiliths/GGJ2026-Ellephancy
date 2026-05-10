class_name Puerta
extends StaticBody2D

@export_enum("NORMAL", "DUNGEON") var tipo_de_puerta : int = 0
#@export var dungeon : PackedScene
@export var activadores : Array[Node2D] = []
#@export var id_puerta : int = 0
#@export var varias_palancas : bool = false
#@export_range(1,3,1) var cant_palancas : int = 1

@export var usa_runas : bool = false
@export_group("Movimiento")
@export_enum("Vertical", "Horizontal") var direccion_de_apertura : String = "Vertical"
@export var timeada : bool = false
@export var empieza_abierta : bool = false
@export var timer : float = 1.0
@export var altura_maxima : float = 250.0
@export var tiempo_de_apertura : float = 3.0

@export_group("Dungeon")
@export var posicion_tp : Marker2D

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var sprite_2d_2: Sprite2D = %Sprite2D2
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var contenedor_de_runas: VBoxContainer = %Control/ContenedorDeRunas
@onready var sonido_puerta_moviendo: FmodEventEmitter2D = $SonidoPuertaMoviendo
@onready var sonido_puerta_impacto: FmodEventEmitter2D = $SonidoPuertaImpacto
@onready var sonido_runas_correctas: FmodEventEmitter2D = $SonidoRunasCorrectas
@onready var timer_tiempo_de_apertura: Timer = $TimerTiempoDeApertura
@onready var timer_puerta: Timer = $TimerPuerta


const RUNA = preload("uid://bvq5bbgfqxbf3")

var contador_id : int = 0
var activadores_activados : Array[Node2D] = []

var player_en_puerta : bool = false

var posicion_original = position.y
var esta_abierta = false
#var fue_abierta = false #parece que no se usa, TODO CONSULTAR

var palancas : Array[Palanca] = []
var palancas_con_runas
var cantidad_de_runas : int = 0
enum TiposDeRunas { NUDO_SIMETRICO, NUDO_ASIMETRICO, TRIQUETRA, CRUZ, TRISKELE, ATOMO }
var runas_correctas = {}
var runas_activadas = {}

var player : Player

signal activado


func _ready() -> void:
	if tipo_de_puerta == 1:
		setup_puerta_dungeon()
	elif tipo_de_puerta == 0:
		sprite_2d_2.hide()
		
	if usa_runas:
		setup_runas()

	if empieza_abierta:
		esta_abierta = true
		sprite_2d.position.y = -altura_maxima
		collision_shape_2d.position.y = -altura_maxima
	else:
		esta_abierta = false
	Global.activar_mecanismo.connect(_on_mecanismo_activado)
	Global.desactivar_mecanismo.connect(_on_mecanismo_desactivado)
	timer_tiempo_de_apertura.set_wait_time(tiempo_de_apertura)
	timer_puerta.set_wait_time(timer)
	sonido_puerta_moviendo.set_parameter("Peso", 5.0)


func _process(_delta: float) -> void:
	sonido_puerta_moviendo.volume = Global.volumen_efectos
	sonido_puerta_impacto.volume = Global.volumen_efectos
	sonido_runas_correctas.volume = Global.volumen_efectos
	
#------------------FUNCIONES-----------------------
func cambiar_estado():
	if esta_abierta:
		cerrar_puerta()
	else:
		abrir_puerta()

func _on_mecanismo_activado(mecanismo):
	if mecanismo in activadores:
		if mecanismo not in activadores_activados:
			activadores_activados.append(mecanismo)
		if activadores_activados == activadores and activadores.size() > 0:
			cambiar_estado()

func _on_mecanismo_desactivado(mecanismo):
	if mecanismo in activadores:
		if activadores_activados == activadores and activadores.size() > 0:
			cambiar_estado()


func abrir_puerta(simular : bool = false):
	var tween_sprite = get_tree().create_tween()
	var tween_colision = get_tree().create_tween()
	tween_sprite.set_trans(Tween.TRANS_QUAD)
	tween_sprite.set_ease(Tween.EASE_IN_OUT)
	match direccion_de_apertura:
		"Vertical":
			tween_sprite.tween_property(sprite_2d, "position:y" , -altura_maxima, tiempo_de_apertura)
			tween_colision.tween_property(collision_shape_2d, "position:y" , -altura_maxima, tiempo_de_apertura)
		"Horizontal":
			tween_sprite.tween_property(sprite_2d, "position:x" , -altura_maxima, tiempo_de_apertura)
			tween_colision.tween_property(collision_shape_2d, "position:x" , -altura_maxima, tiempo_de_apertura)

	esta_abierta = true
	if simular:
		return
	Global.puerta_abierta.emit(global_position, tiempo_de_apertura)
	#var conexiones = Global.get_signal_connection_list("puerta_abierta")
	
	timer_tiempo_de_apertura.start()
	#print("la puerta esta abierta")
	sonido_puerta_moviendo.play()
	Objetivos.objeto_activado.emit(self)

func cerrar_puerta():
	var tween_sprite = get_tree().create_tween()
	var tween_colision = get_tree().create_tween()
	tween_sprite.set_trans(Tween.TRANS_QUAD)
	tween_sprite.set_ease(Tween.EASE_IN_OUT)
	match direccion_de_apertura:
		"Vertical":
			tween_sprite.tween_property(sprite_2d, "position:y" , posicion_original, tiempo_de_apertura)
			tween_colision.tween_property(collision_shape_2d, "position:y" , posicion_original, tiempo_de_apertura)
		"Horizontal":
			tween_sprite.tween_property(sprite_2d, "position:x" , posicion_original, tiempo_de_apertura)
			tween_colision.tween_property(collision_shape_2d, "position:x" , posicion_original, tiempo_de_apertura)
	timer_tiempo_de_apertura.start()
	esta_abierta = false
	sonido_puerta_moviendo.play()


func _on_timer_tiempo_de_apertura_timeout() -> void:
	sonido_puerta_impacto.play()
	sonido_puerta_moviendo.stop()
	if timeada and esta_abierta:
		timer_puerta.start()

func _on_timer_puerta_timeout() -> void:
	if timeada:
		timer_puerta.stop()
		cambiar_estado()

func setup_runas():
	var tipos_disponibles = Runa.TiposDeRunas.values()
	var colores = [Color.RED, Color.MAGENTA, Color.YELLOW, Color.ORANGE, Color.CYAN, Color.GREEN]
	tipos_disponibles.shuffle()
	colores.shuffle()
	var index = 0
	for mecanismo in activadores:
		if mecanismo is Palanca:
			var palanca = mecanismo
			palancas.append(palanca)
			palanca.palanca_con_runa_activada.connect(_on_palanca_con_runa_activada)
			var runa_puerta = RUNA.instantiate()
			contenedor_de_runas.add_child(runa_puerta)
			var tipo = tipos_disponibles[index]
			var color = colores[index]
			index += 1
			runa_puerta.asignar_tipo(tipo, color)
			runa_puerta.z_index = 3
			palanca.color = color
			runas_correctas[tipo] = palanca

func _on_palanca_con_runa_activada(mecanismo, runa: Runa):
	if mecanismo in activadores:
		var tipo = runa.tipo_de_runa
		for key in runas_activadas.keys():
			if runas_activadas[key] == mecanismo:
				runas_activadas.erase(key)
				break
		if runas_correctas.has(tipo) and runas_correctas[tipo] == mecanismo:
			if not runas_activadas.has(tipo):
				runas_activadas[tipo] = mecanismo
				if runas_activadas.keys().size() == runas_correctas.keys().size():
					sonido_runas_correctas.play()
					abrir_puerta()


func setup_puerta_dungeon():
	sprite_2d_2.show()
	collision_shape_2d.disabled = true


func _on_area_puerta_dungeon_body_entered(body: Node2D) -> void:
	if body is Player: 
		player_en_puerta = true
		player = body


func _on_area_puerta_dungeon_body_exited(body: Node2D) -> void:
	if body is Player: 
		player_en_puerta = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interactuar") and esta_abierta and player_en_puerta and tipo_de_puerta == 1:
		entrar_a_dungeon()
		

func entrar_a_dungeon():
	print("entraste a la dungeon")
	Global.guardar_datos()
	Global.teletransportar(player, posicion_tp.global_position)
	#await get_tree().create_timer(1).timeout
	#await get_tree().process_frame
	#get_tree().change_scene_to_packed(dungeon)
#se llaman en global con get_tree().call_group("persistente", "guardar") y para cargar igual
func guardar():
	#print("##### Objeto guardado con la key: ", get_path())
	Global.diccionario_persistentes[get_path()] = {"esta_abierta" = esta_abierta} #guardo con un diccionario adentro de otro



func cargar():
		#print("-- se ejecuto cargar en el objeto empujable  : ", get_path())
	if Global.diccionario_persistentes.has(get_path()):
		#print("-------  ENCONTRE MI KEY EN EL DICCIONARIOOOOO ")
		esta_abierta = Global.diccionario_persistentes[get_path()]["esta_abierta"]
		if esta_abierta:
			simular_activacion()
	else:
		guardar() #si por algun motivo no se habia guardado anteriormente, lo guardo con la posicion actual
		#print("ATENCION ----- NO SE ENCONTRO MI INFO EN EL DICCIONARIO ")


func simular_activacion():
	abrir_puerta(true) #true viende de activar la "simulacion" solo hacemos que se abra sin emitir la signal
