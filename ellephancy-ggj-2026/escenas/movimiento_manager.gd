class_name MovimientoManager
extends Node

enum ESTADOS {IDLE, CAMINAR, SALTAR, CAER, INTERACTUAR, AGARRAR, DIALOGO_ACTIVO}
var estado_actual : ESTADOS = ESTADOS.IDLE
var ultimo_estado : ESTADOS

var body : Player

func setup(jugador : Player):
	body = jugador

func aplicar_gravedad(delta : float):
	if body.velocity.y<0:
		body.velocity += body.get_gravity() * body.STATS.gravedad_subiendo * delta
	else:
		body.velocity += body.get_gravity() * body.STATS.gravedad_bajando * delta

#
func matchear_estado_actual(estado_actual, delta : float):
	match body.estado_actual:
		body.ESTADOS.IDLE:
			body.procesar_idle(delta)
		ESTADOS.CAMINAR:
			body.procesar_caminar(delta)
		ESTADOS.SALTAR:
			body.procesar_saltar(delta)
		ESTADOS.CAER:
			body.procesar_caer(delta)
		ESTADOS.INTERACTUAR:
			pass #por si necesitamos logica en process la ponemos aca
		ESTADOS.AGARRAR:
			body.procesar_agarrar(delta)
		ESTADOS.DIALOGO_ACTIVO:
			body.procesar_dialogo_activo()
#TEST
#
#
#
#
#
#func procesar_idle(delta):
	#velocity.x = move_toward(velocity.x, 0, STATS.desaceleracion * delta)
	#animated_sprite_pj.flip_h = ultima_direccion_mirar <0
	#if not is_on_floor():
		#cambiar_de_estado(ESTADOS.CAER)
		#return
	#if direction != 0: #moviendome
		#cambiar_de_estado(ESTADOS.CAMINAR)
		#return
	#if Input.is_action_just_pressed("w") and (is_on_floor()) and not Input.is_action_pressed("s"): #cambiar a una sola funcion q me devuelva true
		#velocity.y = STATS.velocidad_salto
		#cambiar_de_estado(ESTADOS.SALTAR)
	#if Input.is_action_pressed("s") and Input.is_action_just_pressed("w") and is_on_floor():
		#tirarse_de_plataforma()
#
#func procesar_caminar(delta):
	#velocity.x = move_toward(velocity.x, direction * STATS.velocidad, STATS.aceleracion * delta)
	#animated_sprite_pj.flip_h = ultima_direccion_mirar < 0
	#if direction:
		#if timer_pasos <= 0 && is_on_floor():
			#
			#%FmodEventEmitter2D.play()
			##pasos()
			#timer_pasos = timer_pasos_reset
		#timer_pasos -= delta 
	#if direction == 0:
		#cambiar_de_estado(ESTADOS.IDLE)
		#return
	#if not is_on_floor():
		#cambiar_de_estado(ESTADOS.CAER)
		#return
	#if Input.is_action_just_pressed("w") and is_on_floor():
		#velocity.y = STATS.velocidad_salto
		#cambiar_de_estado(ESTADOS.SALTAR)
	#
#
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
