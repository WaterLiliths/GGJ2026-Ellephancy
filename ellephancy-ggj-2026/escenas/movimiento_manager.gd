class_name MovimientoManager
extends Node
##ESTE MANAGER CONTROLA LOS MOVIMIENTOS DE PLAYER, INCLUYENDO EL STATE MACHINE


@onready var STATS : PlayerStats = %PlayerStats
@onready var animation_manager : AnimationManager = %AnimationManager
@onready var animated_sprite : AnimatedSprite2D = %AnimatedSpritePJ
@onready var sound_manager : SoundManager = %SoundManager
@onready var agarrar_manager : AgarrarManager = %AgarrarManager
var body : Player
var timer_pasos : float = 0
#var direction : float


func _ready() -> void:
	Global.dialogo_activo_to_player.connect(on_dialogo_activo)
	Global.dialogo_desactivado_to_player.connect(on_dialogo_desactivado)

func setup(jugador : Player):
	body = jugador

func on_dialogo_activo():
	cambiar_de_estado(body.ESTADOS.DIALOGO_ACTIVO)

func on_dialogo_desactivado():
	cambiar_de_estado(body.ESTADOS.IDLE)


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

#en el physic del player llamo a matchear estado actual mandandole IDLE
#el mismo IDLE va chequeando si hay cambios, ej : si empieza a haber direccion, cambio de estado a CAMINAR
func matchear_estado_actual(estado_actual, delta : float):
	match estado_actual:
		Player.ESTADOS.IDLE:
			procesar_idle(body.direction, delta)
		Player.ESTADOS.CAMINAR:
			procesar_caminar(body.direction, delta)
		Player.ESTADOS.SALTAR:
			procesar_saltar(body.direction , delta)
		Player.ESTADOS.CAER:
			procesar_caer(body.direction, delta)
		Player.ESTADOS.INTERACTUAR:
			pass #por si necesitamos logica en process la ponemos aca
		Player.ESTADOS.AGARRAR:
			procesar_agarrar(body.direction, delta)
		Player.ESTADOS.DIALOGO_ACTIVO:
			procesar_dialogo_activo(delta)


func procesar_idle(direccion, delta : float):
	desacelerar_a_cero(delta)
	animation_manager.flipear_animation(body.ultima_direccion_mirar)
	if not body.is_on_floor():
		cambiar_de_estado(Player.ESTADOS.CAER)
		return
	if direccion != 0: #moviendome
		cambiar_de_estado(Player.ESTADOS.CAMINAR)
		return
	if puede_saltar():
		body.velocity.y = STATS.velocidad_salto
		cambiar_de_estado(Player.ESTADOS.SALTAR)
	if Input.is_action_pressed("s") and Input.is_action_just_pressed("w") and body.is_on_floor():
		tirarse_de_plataforma()



func cambiar_de_estado(estado_nuevo):
	if body.estado_actual == estado_nuevo:
		return
	body.ultimo_estado = body.estado_actual
	body.estado_actual = estado_nuevo
	matchear_animaciones()

func matchear_animaciones():
	match body.estado_actual:
		Player.ESTADOS.IDLE:
			animation_manager.ejecutar_animacion_idle()
		Player.ESTADOS.CAMINAR:
			animation_manager.ejecutar_animacion_caminar()
		Player.ESTADOS.SALTAR:
			animation_manager.ejecutar_animacion_saltar()
			sound_manager.ejecutar_sonido_salto()
		Player.ESTADOS.CAER:
			animation_manager.ejecutar_animacion_caida()
		Player.ESTADOS.INTERACTUAR:
			animation_manager.ejecutar_animacion_palanca()
		Player.ESTADOS.AGARRAR:
			animation_manager.ejecutar_animacion_arrastrar()
		Player.ESTADOS.DIALOGO_ACTIVO:
			animation_manager.ejecutar_animacion_idle()



func procesar_saltar(direccion, delta : float):
	if direccion:
		movimiento_horizontal(direccion, delta)
		animation_manager.flipear_animation(body.ultima_direccion_mirar)

	if Input.is_action_just_released("w") and body.velocity.y < 0:
		body.velocity.y *= STATS.desaceleración_al_saltar
	
	if body.velocity.y >0:
		cambiar_de_estado(Player.ESTADOS.CAER)


func procesar_caer(direccion, delta : float):
	if direccion:
		movimiento_horizontal(direccion, delta)
		animation_manager.flipear_animation(body.ultima_direccion_mirar)

	if body.is_on_floor():
		if direccion != 0: #moviendome
			cambiar_de_estado(Player.ESTADOS.CAMINAR)
		else:
			cambiar_de_estado(Player.ESTADOS.IDLE)


func procesar_dialogo_activo(delta):
	#print("esta aca en procesar dialogoooooooooooooooooooo")
	body.direction = 0
	desacelerar_a_cero(delta)



func procesar_caminar(direccion, delta):
	#print("estoy en procesar caminar del MANAGERRRRRRRRRR")
	movimiento_horizontal(direccion, delta)
	animation_manager.flipear_animation(body.ultima_direccion_mirar)
	if direccion:
		manejar_sonido_pasos(delta)
	if direccion == 0:
		cambiar_de_estado(Player.ESTADOS.IDLE)
		return
	if not body.is_on_floor():
		cambiar_de_estado(Player.ESTADOS.CAER)
		return
	if puede_saltar():
		body.velocity.y = STATS.velocidad_salto
		cambiar_de_estado(Player.ESTADOS.SALTAR)




func procesar_agarrar(direccion, delta):
	#cuando hago click ya le aviso al player que cambie a la velocidad lenta
	movimiento_horizontal(direccion, delta)
	#if not agarrando_caja: #para evitar bugs, porque en realidad al apretar e se cambia de estado
		#reset_velocidad_normal()
		#mov_manager.cambiar_de_estado(ESTADOS.IDLE)
		#return
	if not agarrar_manager.objeto_empujable:
		return

	#agarrar_manager.objeto_empujable.set_ser_agarrado(direccion, STATS.velocidad, true)
	
	agarrar_manager.objeto_empujable.direccion = direccion
	agarrar_manager.objeto_empujable.velocidad = STATS.velocidad
	agarrar_manager.objeto_empujable.siendo_agarrada = true
	#em el agarrar manager se vuelve a poner en false, en soltar_caja

	if not body.animacion_agarrar_inicial_terminada:
		return #espero hasta que haga la animacion de agarre para pasar a las otras
	if direccion != 0:
		if animated_sprite.animation != "seguir_agarrando":
			animated_sprite.play("seguir_agarrando")
	else:
		if animated_sprite.animation != "agarre_idle":
			animated_sprite.play("agarre_idle")
