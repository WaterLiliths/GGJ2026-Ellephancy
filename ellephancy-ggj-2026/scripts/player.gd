class_name Player
extends CharacterBody2D

@export_group("MODO TESTEO")
@export var estoy_testeando_cosas : bool = false
@export var cargar_datos : bool = false

@export_group("Mobile")
##si ponemos en true se instancia la escena de los botones como hijo de player
@export var jugar_mobile : bool = false

#---------- COMPONENTES / MANAGERS -------
@export_group("Managers")
@export var input_manager : InputManager
@export var sound_manager : SoundManager
@export var animation_manager : AnimationManager
@export var detector_suelo_manager : DetectorSueloManager
@export var mov_manager : MovimientoManager
@export var mascaras_manager : MascarasManager
@export var agarrar_manager : AgarrarManager
@export var interact_manager : InteractuarManager
@export var animation_player : AnimationPlayer
@export var componente_de_vida : ComponenteDeVida
@onready var STATS : PlayerStats = %PlayerStats
#------------------FIN MANAGERS -----------
@export_group("Empezar con mascara")
@export var empezar_con_mascaras : bool = false

#--------------"MANOS" PARA EVITAR TRABARSE CON LA CAJA---------------
#@onready var mano_test_izq: CollisionShape2D = %CollisionManoIzq
#@onready var mano_test_der: CollisionShape2D = %CollisionManoDer
#-------------------------------
var ultimo_tiempo_en_aire : float = 0
var tiempo_en_el_aire_actual: float = 0
var reviviendo_player : bool = false
var ultima_direccion_mirar : int = 1 #para derecha e izquierda solo 1 -1
var sonido_caida_emitiendo : bool = false
var sonido_caja_sonando : bool = false
var agarrando_caja : bool = false

@onready var animated_sprite_pj: AnimatedSprite2D = %AnimatedSpritePJ
@onready var ray_cast_izq: RayCast2D = %RayCastIzq #se usan para las "manos"
@onready var ray_cast_der: RayCast2D = %RayCastDer
var direction : float
var objeto_arrastrado = null
var estaba_en_el_piso : bool = false
var objeto_interactivo : Interactivo = null
var puede_interactuar : bool = false

enum ESTADOS {IDLE, CAMINAR, SALTAR, CAER, INTERACTUAR, AGARRAR, DIALOGO_ACTIVO}
var estado_actual : ESTADOS = ESTADOS.IDLE
var ultimo_estado : ESTADOS


func _ready() -> void:
	interact_manager.setup(self)
	mov_manager.setup(self)
	Global.restart.connect(matar_player)
	agarrar_manager.resetear_velocidad_normal.connect(reset_velocidad_normal)
	agarrar_manager.disminuir_velocidad_agarrando.connect(on_disminuir_velocidad_agarrando)
	mascaras_manager.resetear_mascaras_a_cero(not empezar_con_mascaras) #marcar true o false desde el editor
	if jugar_mobile:
		var botones_android : PackedScene= preload("res://escenas/interfaz_android.tscn") #o cambiar por el uuid
		var instancia_botones = botones_android.instantiate()
		add_child(instancia_botones)
	await get_tree().create_timer(0.1).timeout #el timer QUIZAS no es necesario, pero puede evitar algun q otro bug
	manejar_checkpoint_position()


func _physics_process(delta: float) -> void:
	direction = Input.get_axis("a", "d")
	if direction:
		ultima_direccion_mirar = sign(direction)

	mov_manager.aplicar_gravedad(delta)
	mov_manager.matchear_estado_actual(estado_actual, delta)

	if global_position.y > STATS.limite_altura_morir:
		matar_player()

	move_and_slide()
	calcular_tiempo_en_aire(delta)
	detectar_caida()

	sound_manager.emitir_sonido_caida()
	estaba_en_el_piso = is_on_floor()
	if not sonido_caida_emitiendo: 
		sound_manager.emitir_sonido_caida()
		#------------------------INTERACTUAR------------------------
		#TODO MOVER AL INPUT MANAGER
	if puede_interactuar and objeto_interactivo is Palanca and Input.is_action_just_pressed("interactuar"):
		objeto_interactivo.activar()
		animation_manager.ejecutar_animacion_palanca()

#--------------------  FUNCIONES  ------------------------

func on_entra_a_interactivo(interactivo_actual : Interactivo):
	puede_interactuar = true
	if interactivo_actual is Palanca:
		objeto_interactivo = interactivo_actual

func on_sale_de_interactivo(interactivo_actual : Interactivo):
	if interactivo_actual == objeto_interactivo:
		puede_interactuar = false
		objeto_interactivo = null


func on_disminuir_velocidad_agarrando(peso_caja : float): #señal emitida desde agarrar manager
	#var factor_aumento : float = 7.4
	#var aceleracion_nueva = max(STATS.aceleracion_min_agarrando, STATS.aceleracion - (peso_caja * 200))
	#var velocidad_nueva = max(STATS.velocidad_minima_agarrando, STATS.velocidad_arrastrando - (peso_caja * factor_aumento))
	#STATS.velocidad = velocidad_nueva
	#STATS.aceleracion = aceleracion_nueva
	var factor_peso = inverse_lerp(1, 10, peso_caja)
	var aceleracion_nueva = lerp(STATS.aceleracion, STATS.aceleracion_min_agarrando, factor_peso)
	var velocidad_nueva = lerp(STATS.velocidad_arrastrando, STATS.velocidad_minima_agarrando, factor_peso)
	STATS.velocidad = velocidad_nueva
	STATS.aceleracion = aceleracion_nueva
#	print("MOVER CAJA A VELOCIDAD: ", velocidad_nueva , " Y ACELERACION : ", aceleracion_nueva)


func reset_velocidad_normal(): #se ejecuta en la signal emitida por agarrar manager
	STATS.velocidad = STATS.velocidad_inicial
	STATS.aceleracion = STATS.aceleracion_inicial
	if Global.mascara_activa==2:
		STATS.velocidad_salto = STATS.velocidad_salto_con_mascara
	else:
		STATS.velocidad_salto = STATS.velocidad_inicial_salto


func detectar_caida():
	if not estaba_en_el_piso and is_on_floor():
		%FmodEventEmitter2D4.play() #TODO consultarle a attie 
		%FmodEventEmitter2D5.stop()
		sonido_caida_emitiendo = false
	#	print("DETECTAR CAIDA - ESTUVO ", ultimo_tiempo_en_aire, " TIEMPO EN EL AIRE ")
		if ultimo_tiempo_en_aire > 1.1: #esta harcodeado pero podria ser una variable
			Global.player_detecto_caida.emit(ultimo_tiempo_en_aire)

func calcular_tiempo_en_aire(delta : float):
	if is_on_floor() and tiempo_en_el_aire_actual!=0:
		ultimo_tiempo_en_aire = tiempo_en_el_aire_actual
		tiempo_en_el_aire_actual = 0
	else:
		tiempo_en_el_aire_actual += delta
	#	print("ESTUVO TANTO TIEMPO EN AIREEEE: ", tiempo_en_el_aire)

func consultar_saltar():
	if Input.is_action_just_pressed("w") and is_on_floor():
		velocity.y = STATS.velocidad_salto
		$FmodEventEmitter2D2.play()

func procesar_dialogo_activo():
	#print("esta aca en procesar dialogoooooooooooooooooooo")
	direction = 0
	velocity.x = 0


func matar_player():
	if reviviendo_player:
		return
	reviviendo_player = true
	%FmodEventEmitter2D7.play()
	animation_player.play("fade_out_revivir")
	Global.matar_player.emit()
	set_physics_process(false)
	await get_tree().create_timer(1.5).timeout
	global_position = Global.get_checkpoint_position()
	animation_player.play("fade_in")
	reviviendo_player = false
	componente_de_vida.vida = componente_de_vida.vida_maxima
	set_physics_process(true)

func acaba_de_aterrizar() -> bool:
	return is_on_floor() and velocity.y >= 0

func manejar_checkpoint_position():
	if estoy_testeando_cosas:
		#solo guardo su global position como ya veniamos haciendo e ignoro al config file
		Global.set_checkpoint_position(global_position)
		return
	if Global.checkpoint_position== Vector2.ZERO:
		print("Es la primera vez que entra al juego o NO habia checkpoint en el config file")
		Global.set_checkpoint_position(global_position)
	else:
		print("Ya existia un checkpoint en el config_file, muevo al player ahi")
		global_position = Global.get_checkpoint_position()

#aca habian 600 lineas pode creer 
#o.o omg
