class_name Player
extends CharacterBody2D

##si ponemos en true se instancia la escena de los botones como hijo de player
@export var jugar_mobile : bool = false

#---------- COMPONENTES / MANAGERS -------
@export var input_manager : InputManager
@export var sound_manager : SoundManager
@export var animation_manager : AnimationManager
@export var detector_suelo_manager : DetectorSueloManager
@onready var STATS : PlayerStats = %PlayerStats
#------------------FIN MANAGERS -----------

#--------------"MANOS" PARA EVITAR TRABARSE CON LA CAJA---------------
@onready var mano_test_izq: CollisionShape2D = %CollisionManoIzq
@onready var mano_test_der: CollisionShape2D = %CollisionManoDer
#-------------------------------

var animacion_agarrar_inicial_terminada : bool = false
var ultimo_tiempo_en_aire : float = 0
var tiempo_en_el_aire_actual: float = 0
var dialogos_activos : bool = false
var reviviendo_player : bool = false
var ultima_direccion_mirar : int = 1 #para derecha e izquierda solo 1 -1
var sonido_caida_emitiendo : bool = false
var sonido_caja_sonando : bool = false
var agarrando_caja : bool = false

var velocidad_inicial_salto : float
var velocidad_inicial : float 


@onready var animated_sprite_pj: AnimatedSprite2D = %AnimatedSpritePJ
@onready var ray_cast_izq: RayCast2D = %RayCastIzq
@onready var ray_cast_der: RayCast2D = %RayCastDer
var direction : float
var objeto_arrastrado = null

var timer_pasos = 0
var timer_pasos_reset = 0.36

var estaba_en_el_piso : bool = false
@onready var mascara_tiempo: Node2D = %MascaraTiempos
var objeto_interactivo : Interactivo = null
var puede_interactuar : bool = false

enum ESTADOS {IDLE, CAMINAR, SALTAR, CAER, INTERACTUAR, AGARRAR, DIALOGO_ACTIVO}
var estado_actual : ESTADOS = ESTADOS.IDLE
var ultimo_estado : ESTADOS


func _ready() -> void:
	Global.dialogo_activo_to_player.connect(on_dialogo_activo)
	Global.dialogo_desactivado_to_player.connect(on_dialogo_desactivado)
	resetear_mascaras_a_cero(true) #true para desactivar todas, false para activarlas
	mano_test_izq.set_deferred("disabled", true) #DESACTIVO FISICAS DE LA MANO
	mano_test_der.set_deferred("disabled", true)
	
	velocidad_inicial = STATS.velocidad
	velocidad_inicial_salto = STATS.velocidad_salto
	Global.mascara_fuerza_activa.connect(activar_mascara_fuerza)
	Global.mascara_fuerza_desactivar.connect(desactivar_mascara_fuerza)
	Global.restart.connect(restart)
	if jugar_mobile:
		var botones_android : PackedScene= preload("res://escenas/interfaz_android.tscn") #o cambiar por el uuid
		var instancia_botones = botones_android.instantiate()
		add_child(instancia_botones)
	await get_tree().create_timer(0.5).timeout #el timer QUIZAS no es necesario, pero puede evitar algun q otro bug
	Global.set_checkpoint_position(global_position)


func _physics_process(delta: float) -> void:
	%FmodEventEmitter2D.volume = Global.volumen_efectos
	%FmodEventEmitter2D4.volume = Global.volumen_efectos
	%FmodEventEmitter2D2.volume = Global.volumen_efectos

	if not dialogos_activos: #TEST A VER SI NOS GUSTA
		direction = Input.get_axis("a", "d")
	else:
		direction = 0
	if direction:
		ultima_direccion_mirar = sign(direction)
	aplicar_gravedad(delta)
	
	match estado_actual:
		ESTADOS.IDLE:
			procesar_idle(delta)
		ESTADOS.CAMINAR:
			procesar_caminar(delta)
		ESTADOS.SALTAR:
			procesar_saltar(delta)
		ESTADOS.CAER:
			procesar_caer(delta)
		ESTADOS.INTERACTUAR:
			pass #por si necesitan logica en process la ponemos aca
		ESTADOS.AGARRAR:
			procesar_agarrar(delta)
		ESTADOS.DIALOGO_ACTIVO:
			procesar_dialogo_activo()
	if global_position.y > STATS.limite_altura_morir:
		matar_player()
	
	move_and_slide()
	calcular_tiempo_en_aire(delta)
	detectar_caida()



	if agarrando_caja and direction:
		if not sonido_caja_sonando:
			%FmodEventEmitter2D3.set_parameter("peso", 5.0)
			%FmodEventEmitter2D3.play()
			if objeto_arrastrado:
				%FmodEventEmitter2D3.set_parameter("peso", 5.0)
				sonido_caja_sonando = true
	else:
		if sonido_caja_sonando:
			%FmodEventEmitter2D3.stop()
			sonido_caja_sonando = false


	emitir_sonido_caida()
	estaba_en_el_piso = is_on_floor()
	if not sonido_caida_emitiendo: 
		emitir_sonido_caida()
		#------------------------INTERACTUAR------------------------
	if puede_interactuar and objeto_interactivo is Palanca and Input.is_action_just_pressed("interactuar"):
		objeto_interactivo.activar()
		#ejecutar_animacion_palanca()


#--------------------- SEÑALES  -------------------------
func _on_area_tirar_body_entered(body: Node2D) -> void:
#	if body is ObjetoEmpujable or body.is_in_group("cajas"):
	if body.is_in_group("cajas") and body != Player:
		objeto_arrastrado = body

func _on_area_tirar_body_exited(body: Node2D) -> void:
	if body.is_in_group("cajas") and body != Player:
		soltar_caja()
		objeto_arrastrado = null

#--------------------  FUNCIONES  ------------------------


func on_entra_a_interactivo(interactivo_actual : Interactivo):
	puede_interactuar = true
	if interactivo_actual is Palanca:
		objeto_interactivo = interactivo_actual

func on_sale_de_interactivo(interactivo_actual : Interactivo):
	if interactivo_actual == objeto_interactivo:
		puede_interactuar = false
		objeto_interactivo = null


func activar_mascara_fuerza():
	STATS.velocidad_salto = STATS.velocidad_salto_con_mascara


func desactivar_mascara_fuerza():
	STATS.velocidad_salto = velocidad_inicial_salto
	print("se desactivo las mascara de fuerza")

func disminuir_velocidad_al_agarrar():
	STATS.velocidad = STATS.velocidad_arrastrando

func reset_velocidad_normal():
	STATS.velocidad = velocidad_inicial
	if Global.mascara_activa==2:
		STATS.velocidad_salto = STATS.velocidad_salto_con_mascara
	else:
		STATS.velocidad_salto = STATS.velocidad_inicial_salto


func detectar_caida():
	if not estaba_en_el_piso and is_on_floor():
		%FmodEventEmitter2D4.play()
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


func emitir_sonido_caida():
	if estaba_en_el_piso and not is_on_floor():
		%FmodEventEmitter2D5.play()
		sonido_caida_emitiendo = true


func aplicar_gravedad(delta : float):
	if velocity.y<0:
		velocity += get_gravity() * STATS.gravedad_subiendo * delta
	else:
		velocity += get_gravity() * STATS.gravedad_bajando * delta


func procesar_idle(delta):
	velocity.x = move_toward(velocity.x, 0, STATS.desaceleracion * delta)
	animated_sprite_pj.flip_h = ultima_direccion_mirar <0
	if not is_on_floor():
		cambiar_de_estado(ESTADOS.CAER)
		return
	if direction != 0: #moviendome
		cambiar_de_estado(ESTADOS.CAMINAR)
		return
	if Input.is_action_just_pressed("w") and (is_on_floor()) and not Input.is_action_pressed("s"): #cambiar a una sola funcion q me devuelva true
		velocity.y = STATS.velocidad_salto
		cambiar_de_estado(ESTADOS.SALTAR)
	if Input.is_action_pressed("s") and Input.is_action_just_pressed("w") and is_on_floor():
		tirarse_de_plataforma()

func procesar_caminar(delta):
	velocity.x = move_toward(velocity.x, direction * STATS.velocidad, STATS.aceleracion * delta)
	animated_sprite_pj.flip_h = ultima_direccion_mirar < 0
	if direction:
		if timer_pasos <= 0 && is_on_floor():
			
			%FmodEventEmitter2D.play()
			#pasos()
			timer_pasos = timer_pasos_reset
		timer_pasos -= delta 
	if direction == 0:
		cambiar_de_estado(ESTADOS.IDLE)
		return
	if not is_on_floor():
		cambiar_de_estado(ESTADOS.CAER)
		return
	if Input.is_action_just_pressed("w") and is_on_floor():
		velocity.y = STATS.velocidad_salto
		cambiar_de_estado(ESTADOS.SALTAR)
	

func procesar_saltar(delta):
	if direction:
		velocity.x = move_toward(velocity.x , direction * STATS.velocidad, STATS.aceleracion * delta)
		animated_sprite_pj.flip_h = ultima_direccion_mirar < 0 #rotar pj segun para donde se mueve
	
	if Input.is_action_just_released("w") and velocity.y < 0: #probar
		velocity.y *= STATS.desaceleración_al_saltar
	
	if velocity.y >0: #TODO TESTEAR 
		cambiar_de_estado(ESTADOS.CAER)

func procesar_caer(delta):
	if direction:
		velocity.x = move_toward(velocity.x , direction * STATS.velocidad, STATS.aceleracion * delta)
		animated_sprite_pj.flip_h = ultima_direccion_mirar < 0 #rotar pj segun para donde se mueve
	
	if is_on_floor():
		if direction != 0: #moviendome
			cambiar_de_estado(ESTADOS.CAMINAR)
		else:
			cambiar_de_estado(ESTADOS.IDLE)


func procesar_agarrar(delta):
	#cuando hago click ya le aviso al player que cambie a la velocidad lenta
	velocity.x = move_toward(velocity.x,direction * STATS.velocidad, STATS.aceleracion * delta)
	if not agarrando_caja: #para evitar bugs, porque en realidad al apretar e se cambia de estado
		reset_velocidad_normal()
		cambiar_de_estado(ESTADOS.IDLE)
		return
	if not objeto_arrastrado:
		return
	
	objeto_arrastrado.direccion = direction
	objeto_arrastrado.velocidad = STATS.velocidad
	objeto_arrastrado.siendo_agarrada = true

	if not animacion_agarrar_inicial_terminada:
		return #espero hasta que haga la animacion de agarre para pasar a las otras
	if direction != 0:
		if animated_sprite_pj.animation != "seguir_agarrando":
			animated_sprite_pj.play("seguir_agarrando")
	else:
		if animated_sprite_pj.animation != "agarre_idle":
			animated_sprite_pj.play("agarre_idle")

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

func activar_mano():
	if agarrando_caja:
		return
	ray_cast_izq.force_raycast_update()
	ray_cast_der.force_raycast_update()
	if ray_cast_izq.is_colliding() and ray_cast_der.is_colliding(): #ahi me aseguro que esta "encerrado" y solo en ese caso q active la mano
		mano_test_izq.set_deferred("disabled", false) #ACTIVO FISICAS DE LA MANO
		mano_test_der.set_deferred("disabled", false) #ACTIVO FISICAS DE LA MANO
		await get_tree().create_timer(0.1).timeout
		mano_test_izq.set_deferred("disabled", true) #y aca las vuelvo a desactivar
		mano_test_der.set_deferred("disabled", true)


func resetear_mascaras_a_cero(estado : bool):
	if estado == true:
		Global.tiene_mascara_fuerza = false
		Global.tiene_mascara_tiempo = false
		Global.tiene_mascara_traducciones = false
		Global.mascara_activa = 0 #esto faltaba pq cuando terminabas el juego tenias la del oso puesta
	else: #esto lo agrego para que sea mas facil activar y desactivar con una sola funcion
		Global.tiene_mascara_fuerza = true
		Global.tiene_mascara_tiempo = true
		Global.tiene_mascara_traducciones = true

func on_dialogo_activo():
	cambiar_de_estado(ESTADOS.DIALOGO_ACTIVO)

func on_dialogo_desactivado():
	cambiar_de_estado(ESTADOS.IDLE)

func restart():
	matar_player()


func agarrar_caja():
	if not is_on_floor():
		return
	var direccion_con_caja = sign(global_position.x- objeto_arrastrado.global_position.x)
	#direccion -1 es esta a tu derecha, 1 es que esta a tu izquierda
	if ultima_direccion_mirar == direccion_con_caja: #aunque diga == significa que son direcciones opuestas
		#print("NO AGARRAR, ESTAS MIRANDO OPUESTO A LA CAJA")
		return
	disminuir_velocidad_al_agarrar()
	cambiar_de_estado(ESTADOS.AGARRAR)
	animacion_agarrar_inicial_terminada = false
	animated_sprite_pj.play("agarrar_oso")
	agarrando_caja = true


func soltar_caja():
	if not agarrando_caja:
		return
	objeto_arrastrado.siendo_agarrada = false
	reset_velocidad_normal()
	cambiar_de_estado(ESTADOS.IDLE)
	agarrando_caja = false
	activar_mano() #TEST ver si sigue haciendo falta ahora que las cajas se pueden empujar


func cambiar_de_estado(estado_nuevo : ESTADOS):
	if estado_actual == estado_nuevo:
		return
	ultimo_estado = estado_actual
	estado_actual = estado_nuevo
	match estado_actual:
		ESTADOS.IDLE:
			animation_manager.ejecutar_animacion_idle()
		ESTADOS.CAMINAR:
			animation_manager.ejecutar_animacion_caminar()
		ESTADOS.SALTAR:
			animation_manager.ejecutar_animacion_saltar()
			sound_manager.ejecutar_sonido_salto()
		ESTADOS.CAER:
			animation_manager.ejecutar_animacion_caida()
		ESTADOS.INTERACTUAR:
			animation_manager.ejecutar_animacion_palanca()
		ESTADOS.AGARRAR:
			animation_manager.ejecutar_animacion_arrastrar()
		ESTADOS.DIALOGO_ACTIVO:
			animation_manager.ejecutar_animacion_idle()


#si estas leyendo esto es pq termine de refactorizar a player
#porfin pordiossssss gracias Messi
#igual tarde pq player ya me dejo asi: https://www.youtube.com/watch?v=HdHL3j2trWk
