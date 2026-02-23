class_name Player
extends CharacterBody2D

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
@onready var STATS : PlayerStats = %PlayerStats
#------------------FIN MANAGERS -----------
@export_group("Empezar con mascara")
@export var empezar_con_mascaras : bool = false

#--------------"MANOS" PARA EVITAR TRABARSE CON LA CAJA---------------
#@onready var mano_test_izq: CollisionShape2D = %CollisionManoIzq
#@onready var mano_test_der: CollisionShape2D = %CollisionManoDer
#-------------------------------
var animacion_agarrar_inicial_terminada : bool = false #NO BORRAR esta variable es una EXCEPCION, la necesitan movimiento manager y agarrar manager, no me gusta que tenga tanta dependencia, pero es una solucion temporal
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
	Global.restart.connect(restart)
	agarrar_manager.resetear_velocidad_normal.connect(reset_velocidad_normal)
	mascaras_manager.resetear_mascaras_a_cero(not empezar_con_mascaras) #marcar true o false desde el editor
	if jugar_mobile:
		var botones_android : PackedScene= preload("res://escenas/interfaz_android.tscn") #o cambiar por el uuid
		var instancia_botones = botones_android.instantiate()
		add_child(instancia_botones)
	await get_tree().create_timer(0.5).timeout #el timer QUIZAS no es necesario, pero puede evitar algun q otro bug
	Global.set_checkpoint_position(global_position)



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


func reset_velocidad_normal(): #se ejecuta en la signal emitida por agarrar manager
	STATS.velocidad = STATS.velocidad_inicial
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
	global_position = Global.get_checkpoint_position()
	Global.matar_player.emit()
	%FmodEventEmitter2D7.play()
	reviviendo_player = false

func tirarse_de_plataforma():
	position.y += 1


func acaba_de_aterrizar() -> bool:
	return is_on_floor() and velocity.y >= 0

func restart():
	matar_player()
