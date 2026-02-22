class_name MovimientoManager
extends Node
##ESTE MANAGER CONTROLA LOS MOVIMIENTOS DE PLAYER, INCLUYENDO EL STATE MACHINE

enum ESTADOS {IDLE, CAMINAR, SALTAR, CAER, INTERACTUAR, AGARRAR, DIALOGO_ACTIVO}
var estado_actual : ESTADOS = ESTADOS.IDLE
var ultimo_estado : ESTADOS
@onready var STATS : PlayerStats = %PlayerStats
@onready var animation_manager : AnimationManager = %AnimationManager
@onready var sound_manager : SoundManager = %SoundManager
var body : Player
var timer_pasos : float = 0
#var direction : float

func setup(jugador : Player):
	body = jugador


#func pedir_direccion():
	#if not dialogos_activos: #TEST A VER SI NOS GUSTA
		#direction = Input.get_axis("a", "d")
	#else:
		#direction = 0

func aplicar_gravedad(delta : float):
	if body.velocity.y<0:
		body.velocity += body.get_gravity() * body.STATS.gravedad_subiendo * delta
	else:
		body.velocity += body.get_gravity() * body.STATS.gravedad_bajando * delta

func puede_saltar():
	if Input.is_action_just_pressed("w") and body.is_on_floor() and not Input.is_action_pressed("s"):
		return true
	else:
		return false

func tirarse_de_plataforma():
	body.position.y += 1


func movimiento_horizontal(direccion , delta  :float):
	body.velocity.x = move_toward(body.velocity.x, direccion * STATS.velocidad, STATS.aceleracion * delta)

func desacelerar_a_cero(delta : float):
	body.velocity.x = move_toward(body.velocity.x, 0, STATS.desaceleracion * delta)

func manejar_sonido_pasos(delta):
	if timer_pasos <= 0 and body.is_on_floor():
		sound_manager.ejecutar_sonido_pasos()
		timer_pasos = 0.36 #es el valor de reset
	timer_pasos -= delta #con esto mas o menos suena cuando timer pasos vale -0.0066


func matchear_estado_actual(estado_actual, delta : float):
	match estado_actual:
		ESTADOS.IDLE:
			procesar_idle(body.direction, delta)
		ESTADOS.CAMINAR:
			procesar_caminar(body.direction, delta)
		ESTADOS.SALTAR:
			procesar_saltar(body.direction , delta)
		ESTADOS.CAER:
			procesar_caer(body.direction, delta)
		ESTADOS.INTERACTUAR:
			pass #por si necesitamos logica en process la ponemos aca
		ESTADOS.AGARRAR:
			body.procesar_agarrar(delta)
		ESTADOS.DIALOGO_ACTIVO:
			procesar_dialogo_activo(delta)



func procesar_idle(direccion, delta : float):
	desacelerar_a_cero(delta)
	animation_manager.flipear_animation(body.ultima_direccion_mirar)
	if not body.is_on_floor():
		cambiar_de_estado(ESTADOS.CAER)
		return
	if direccion != 0: #moviendome
		cambiar_de_estado(ESTADOS.CAMINAR)
		return
	if puede_saltar():
		body.velocity.y = STATS.velocidad_salto
		cambiar_de_estado(ESTADOS.SALTAR)
	if Input.is_action_pressed("s") and Input.is_action_just_pressed("w") and body.is_on_floor():
		tirarse_de_plataforma()



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



func procesar_saltar(direccion, delta : float):
	if direccion:
		movimiento_horizontal(direccion, delta)
		animation_manager.flipear_animation(body.ultima_direccion_mirar)

	if Input.is_action_just_released("w") and body.velocity.y < 0:
		body.velocity.y *= STATS.desaceleración_al_saltar
	
	if body.velocity.y >0:
		cambiar_de_estado(ESTADOS.CAER)


func procesar_caer(direccion, delta : float):
	if direccion:
		movimiento_horizontal(direccion, delta)
		animation_manager.flipear_animation(body.ultima_direccion_mirar)

	if body.is_on_floor():
		if direccion != 0: #moviendome
			cambiar_de_estado(ESTADOS.CAMINAR)
		else:
			cambiar_de_estado(ESTADOS.IDLE)


func procesar_dialogo_activo(delta):
	#print("esta aca en procesar dialogoooooooooooooooooooo")
	body.direction = 0
	desacelerar_a_cero(delta)



func procesar_caminar(direccion, delta):
	print("estoy en procesar caminar del MANAGERRRRRRRRRR")
	movimiento_horizontal(direccion, delta)
	animation_manager.flipear_animation(body.ultima_direccion_mirar)
	if direccion:
		manejar_sonido_pasos(delta)
	if direccion == 0:
		cambiar_de_estado(ESTADOS.IDLE)
		return
	if not body.is_on_floor():
		cambiar_de_estado(ESTADOS.CAER)
		return
	if puede_saltar():
		body.velocity.y = STATS.velocidad_salto
		cambiar_de_estado(ESTADOS.SALTAR)






#func procesar_saltar(delta):
	#if direction:
		#velocity.x = move_toward(velocity.x , direction * STATS.velocidad, STATS.aceleracion * delta)
		#animated_sprite_pj.flip_h = ultima_direccion_mirar < 0 #rotar pj segun para donde se mueve
	#
	#if Input.is_action_just_released("w") and velocity.y < 0: #probar
		#velocity.y *= STATS.desaceleración_al_saltar
	#
	#if velocity.y >0: #TODO TESTEAR 
		#cambiar_de_estado(ESTADOS.CAER)
#
#func procesar_caer(delta):
	#if direction:
		#velocity.x = move_toward(velocity.x , direction * STATS.velocidad, STATS.aceleracion * delta)
		#animated_sprite_pj.flip_h = ultima_direccion_mirar < 0 #rotar pj segun para donde se mueve
	#
	#if is_on_floor():
		#if direction != 0: #moviendome
			#cambiar_de_estado(ESTADOS.CAMINAR)
		#else:
			#cambiar_de_estado(ESTADOS.IDLE)
#
#
#func procesar_agarrar(delta):
	##cuando hago click ya le aviso al player que cambie a la velocidad lenta
	#velocity.x = move_toward(velocity.x,direction * STATS.velocidad, STATS.aceleracion * delta)
	#if not agarrando_caja: #para evitar bugs, porque en realidad al apretar e se cambia de estado
		#reset_velocidad_normal()
		#cambiar_de_estado(ESTADOS.IDLE)
		#return
	#if not objeto_arrastrado:
		#return
	#
	#objeto_arrastrado.direccion = direction
	#objeto_arrastrado.velocidad = STATS.velocidad
	#objeto_arrastrado.siendo_agarrada = true
#
	#if not animacion_agarrar_inicial_terminada:
		#return #espero hasta que haga la animacion de agarre para pasar a las otras
	#if direction != 0:
		#if animated_sprite_pj.animation != "seguir_agarrando":
			#animated_sprite_pj.play("seguir_agarrando")
	#else:
		#if animated_sprite_pj.animation != "agarre_idle":
			#animated_sprite_pj.play("agarre_idle")
#
#func procesar_dialogo_activo():
	##print("esta aca en procesar dialogoooooooooooooooooooo")
	#direction = 0
	#velocity.x = 0
