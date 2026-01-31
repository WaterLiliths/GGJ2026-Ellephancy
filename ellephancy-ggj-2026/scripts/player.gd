class_name Player
extends CharacterBody2D
#comentario para forzar github CON CHECKPOINT
#---------- mascaras -----------
@onready var mascara_tiempos: Node2D = %MascaraTiempos
@onready var mascara_fuerza: Node2D = %MascaraFuerza
@onready var mascara_traducciones: Node2D = %MascaraTraducciones
#-------------------------------
@export var limite_altura_morir : float = 3000
var reviviendo_player : bool = false
var ultima_direccion_mirar : int = 1 #para derecha e izquierda solo 1 -1
var sonido_caida_emitiendo : bool = false
var sonido_caja_sonando : bool = false
var agarrando_caja : bool = false
@export_range(0,10,0.1) var tiempo_maximo_en_aire : float
@export var aceleracion : float = 1800.0
@export var desaceleracion : float = 2200.0
@export var velocidad_max : float = 250.0
@export var gravedad_subiendo : float = 1.0
@export var gravedad_bajando : float = 1.4
@export var velocidad : float = 250.0
@export var velocidad_salto: float = -500
@export var velocidad_salto_con_mascara = -620
@export var desaceleración_al_saltar : float = 0.5 #arreglar igual 0.5 safa
@export var desaceleracion_horizontal : float = 0.07 #ajustable a gusto
var velocidad_inicial_salto : float
var velocidad_inicial : float 
@export var velocidad_al_agarrar : float = 250
@export var velocidad_correr : float = 40
@export var fuerza_empuje : float = 0
@export var velocidad_arrastrando : float = 100.0

@export var tiene_mascara_fuerza = Global.tiene_mascara_fuerza
@export var tiene_mascara_tiempo = Global.tiene_mascara_tiempo
@export var tiene_mascara_traducciones = Global.tiene_mascara_traducciones

@onready var animated_sprite_pj: AnimatedSprite2D = %AnimatedSpritePJ
@onready var ray_cast_izq: RayCast2D = %RayCastIzq
@onready var ray_cast_der: RayCast2D = %RayCastDer
@onready var pin_joint_agarrar: PinJoint2D = %PinJointAgarrar
var direction : float
var objeto_arrastrado : ObjetoEmpujable = null
@onready var timer_tiempo_en_aire: Timer = %TimerTiempoEnAire
var timer_pasos = 0
var timer_pasos_reset = 0.36

@onready var timer_coyote_time : Timer = %TimerCoyoteTime
var estaba_en_el_piso : bool = false
@onready var mascara_tiempo: Node2D = %MascaraTiempos
var objeto_interactivo : Interactivo = null
var puede_interactuar : bool = false


enum ESTADOS {IDLE, CAMINAR, SALTAR, CAER, INTERACTUAR, AGARRAR}
var estado_actual : ESTADOS = ESTADOS.IDLE

func _ready() -> void:
	timer_tiempo_en_aire.wait_time = tiempo_maximo_en_aire
	velocidad_inicial = velocidad
	velocidad_inicial_salto = velocidad_salto
	Global.mascara_fuerza_activa.connect(activar_mascara_fuerza)
	Global.mascara_fuerza_desactivar.connect(desactivar_mascara_fuerza)
	Global.tiene_mascara_fuerza = tiene_mascara_fuerza
	Global.tiene_mascara_tiempo = tiene_mascara_tiempo
	Global.tiene_mascara_traducciones = tiene_mascara_traducciones

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"): #usar mascara fuerza
		if not Global.tiene_mascara_fuerza:
			print("no tengo la mascara de la fuerza")
			return
		mascara_tiempo.desactivar()
		mascara_fuerza.usar()
		$FmodEventEmitter2D6.set_parameter("Mascara", 0)
		$FmodEventEmitter2D6.play()
		mascara_traducciones.desactivar()
	verificar_animacion_con_mascara()
	if Input.is_action_just_pressed("2"): #usar mascara tiempos
		if not Global.tiene_mascara_tiempo:
			print("no tengo la mascara del tiempo")
			return
		mascara_tiempo.usar()
		$FmodEventEmitter2D6.set_parameter("Mascara", 2)
		$FmodEventEmitter2D6.play()
		mascara_fuerza.desactivar()
		mascara_traducciones.desactivar()
	verificar_animacion_con_mascara()
	if Input.is_action_just_pressed("3"): #usar mascara traducciones
		if not Global.tiene_mascara_traducciones:
			print("no tengo la mascara de las traducciones")
			return
		mascara_tiempo.desactivar()
		mascara_fuerza.desactivar()
		mascara_traducciones.usar()
		$FmodEventEmitter2D6.set_parameter("Mascara", 1)
		$FmodEventEmitter2D6.play()
	verificar_animacion_con_mascara()

	if Input.is_action_just_pressed("tirar") and objeto_arrastrado and Global.mascara_activa==2:
		conectar_caja_con_joint()
	if Input.is_action_just_released("tirar"): # TODO 
		desconectar_caja_con_joint()



func _physics_process(delta: float) -> void:
	direction = Input.get_axis("a", "d")
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
	if global_position.y > limite_altura_morir:
		matar_player()
	
	
	
	
	
	
	
	# -------------------- salto + coyote timer  -------------------------------
	#if Input.is_action_just_pressed("w") and (is_on_floor() or puedo_usar_coyote()):
		#velocity.y = velocidad_salto
		#timer_coyote_time.stop()
		#$FmodEventEmitter2D2.play_one_shot()
		#ejecutar_animacion_saltar()
	#if Input.is_action_just_released("w") and velocity.y < 0:
		#velocity.y *= desaceleración_al_saltar
	
	#movimiento_wasd(delta)
	move_and_slide()
	detectar_caida()
	comprobar_coyote_timer()
	
	
	
	if agarrando_caja and direction:
		if not sonido_caja_sonando:
			%FmodEventEmitter2D3.play()
			if objeto_arrastrado:
				%FmodEventEmitter2D3.set_parameter("peso", objeto_arrastrado.mass) #BUG ACA
				sonido_caja_sonando = true
	else:
		if sonido_caja_sonando:
			%FmodEventEmitter2D3.stop()
			sonido_caja_sonando = false

	#if velocity.y > 0:
		#ejecutar_animacion_caida()

	if is_on_floor():
		timer_coyote_time.stop()
	emitir_sonido_caida()
	estaba_en_el_piso = is_on_floor()
	if not sonido_caida_emitiendo: 
		emitir_sonido_caida()
		#------------------------INTERACTUAR------------------------
	if puede_interactuar and objeto_interactivo is Palanca and Input.is_action_just_pressed("interactuar"):
		objeto_interactivo.activar()
		ejecutar_animacion_palanca()


#--------------------- SEÑALES  -------------------------
func _on_area_tirar_body_entered(body: Node2D) -> void:
	if body is ObjetoEmpujable:
		objeto_arrastrado = body

func _on_area_tirar_body_exited(body: Node2D) -> void:
	if body == objeto_arrastrado:
		objeto_arrastrado = null

#--------------------  FUNCIONES  ------------------------

func conectar_caja_con_joint():
	if agarrando_caja:
		return
	agarrando_caja = true
	pin_joint_agarrar.node_b = objeto_arrastrado.get_path()
	disminuir_velocidad_al_agarrar()
	cambiar_de_estado(ESTADOS.AGARRAR)
	


func desconectar_caja_con_joint():
	pin_joint_agarrar.node_b = self.get_path()# me vuelvo a conectar a mi mismo que es lo mismo q desconectar
	objeto_arrastrado = null
	reset_velocidad_normal()
	agarrando_caja = false
	cambiar_de_estado(ESTADOS.IDLE)


func comprobar_coyote_timer():
	if estaba_en_el_piso and not is_on_floor():#osea que recien salto
		timer_coyote_time.start()
		#sumo tambien para saber cuanto tiempo estaba en el aire
		timer_tiempo_en_aire.start()

func on_entra_a_interactivo(interactivo_actual : Interactivo):
	puede_interactuar = true
	if interactivo_actual is Palanca:
		objeto_interactivo = interactivo_actual

func on_sale_de_interactivo(interactivo_actual : Interactivo):
	if interactivo_actual == objeto_interactivo:
		puede_interactuar = false
		objeto_interactivo = null

func puedo_usar_coyote():
	if timer_coyote_time.time_left > 0 and  algun_raycast_colisiona():
		return true
	else:
		return false

func algun_raycast_colisiona(): #para el coyote timer
	if ray_cast_der.is_colliding():
		return true
	if ray_cast_izq.is_colliding():
		return true


func activar_mascara_fuerza():
	velocidad_salto = velocidad_salto_con_mascara


func desactivar_mascara_fuerza():
	velocidad_salto = velocidad_inicial_salto
	print("se desactivo las mascara de fuerza")


func disminuir_velocidad_al_agarrar():
	velocidad *= (1 / objeto_arrastrado.mass)
	#print((1 / objeto_arrastrado.mass))
	#print("la velocidad de movimiento es: " + str(velocidad))
	velocidad_salto *= (1 / objeto_arrastrado.mass)

func reset_velocidad_normal():
	velocidad = velocidad_inicial
	if Global.mascara_activa==2:
		velocidad_salto = velocidad_salto_con_mascara
	else:
		velocidad_salto = velocidad_inicial_salto


func detectar_caida():
	if not estaba_en_el_piso and is_on_floor():
		var tiempo_en_aire_actual = tiempo_maximo_en_aire - timer_tiempo_en_aire.time_left
		#print("tiempo en aire actual vale: ", tiempo_en_aire_actual)
		$FmodEventEmitter2D4.play_one_shot()
		$FmodEventEmitter2D5.stop()
		sonido_caida_emitiendo = false


func _on_timer_tiempo_en_aire_timeout() -> void:
	#print("Estuvo MUCHO tiempo en el aire, matar personaje")
	pass
	#y dsp aca agregamos funcion kill

func consultar_saltar():
	if Input.is_action_just_pressed("w") and (is_on_floor() or puedo_usar_coyote()):
		velocity.y = velocidad_salto
		timer_coyote_time.stop()
		$FmodEventEmitter2D2.play_one_shot()


func emitir_sonido_pasos():
	%FmodEventEmitter2D.play_one_shot()


func emitir_sonido_caida():
	if estaba_en_el_piso and not is_on_floor():
		$FmodEventEmitter2D5.play()
		sonido_caida_emitiendo = true


func aplicar_gravedad(delta : float):
	if velocity.y<0:
		velocity += get_gravity() * gravedad_subiendo * delta
	else:
		velocity += get_gravity() * gravedad_bajando * delta


func movimiento_wasd(delta : float): #ya no se usa
	if direction:
		#velocity.x = move_toward(velocity.x , direction * velocidad, aceleracion * delta)
		#animated_sprite_pj.flip_h = ultima_direccion_mirar < 0 #rotar pj segun para donde se mueve
		#if is_on_floor():
			#ejecutar_animacion_caminar()
		#else:
			#ejecutar_animacion_saltar()
		#
		if timer_pasos <= 0 && is_on_floor():
			%FmodEventEmitter2D.play_one_shot()
			timer_pasos = timer_pasos_reset
		timer_pasos -= delta 
	#else:
		#velocity.x = move_toward(velocity.x, 0, desaceleracion*delta)
		#if is_on_floor():
			#if abs(velocity.y) <1:
				#animated_sprite_pj.play("idle_normal")
		#else:
			#ejecutar_animacion_saltar()



func ejecutar_animacion_caminar(forzar_id : int = 0): #por si queremos forzar una especifica
	match Global.mascara_activa:
		0:
			animated_sprite_pj.play("caminar_normal")
		1:
			animated_sprite_pj.play("caminar_ciervo")
		2:
			animated_sprite_pj.play("caminar_oso")
		3:
			animated_sprite_pj.play("caminar_salmon")


func ejecutar_animacion_saltar(forzar_id : int = 0): #por si queremos forzar una especifica
	match Global.mascara_activa:
		0:
			animated_sprite_pj.play("salto-normal")
		1:
			animated_sprite_pj.play("salto_ciervo")
		2:
			animated_sprite_pj.play("salto_oso")
		3:
			animated_sprite_pj.play("salto_salmon")


func ejecutar_animacion_arrastrar(): #solo puede el oso
	animated_sprite_pj.play("seguir_agarrando")


func ejecutar_animacion_palanca(forzar_id : int = 0): #por si queremos forzar una especifica
	match Global.mascara_activa:
		0:
			animated_sprite_pj.play("palanca_normal")
		1:
			animated_sprite_pj.play("palanca_ciervo")
		2:
			animated_sprite_pj.play("palanca_oso")
		3:
			animated_sprite_pj.play("palanca_salmon")


func ejecutar_animacion_idle(forzar_id : int = 0): #por si queremos forzar una especifica
	match Global.mascara_activa:
		0:
			animated_sprite_pj.play("idle_normal")
		1:
			animated_sprite_pj.play("idle_ciervo")
		2:
			animated_sprite_pj.play("idle_oso")
		3:
			animated_sprite_pj.play("idle_salmon")



func ejecutar_animacion_caida(forzar_id : int = 0): #por si queremos forzar una especifica
	match Global.mascara_activa:
		0:
			animated_sprite_pj.play("caida_normal")
		1:
			animated_sprite_pj.play("caida_ciervo")
		2:
			animated_sprite_pj.play("caida_oso")
		3:
			animated_sprite_pj.play("caida_salmon")

#TODO ARREGLAR ANIMACIONES
#TODO IDLE SE EJECUTA CUANDO NO CORRESPONDE

func cambiar_de_estado(estado_nuevo : ESTADOS):
	if estado_actual == estado_nuevo:
		return
	estado_actual = estado_nuevo
	match estado_actual:
		ESTADOS.IDLE:
			ejecutar_animacion_idle()
		ESTADOS.CAMINAR:
			ejecutar_animacion_caminar()
		ESTADOS.SALTAR:
			ejecutar_animacion_saltar()
			$FmodEventEmitter2D2.play_one_shot()
		ESTADOS.CAER:
			ejecutar_animacion_caida()
		ESTADOS.INTERACTUAR:
			ejecutar_animacion_palanca()
		ESTADOS.AGARRAR:
			ejecutar_animacion_arrastrar()


func procesar_idle(delta):
	velocity.x = move_toward(velocity.x, 0, desaceleracion * delta)
	animated_sprite_pj.flip_h = ultima_direccion_mirar <0
	if not is_on_floor():
		cambiar_de_estado(ESTADOS.CAER) #o pasar a salto? TODO TESTEAR
		return
	if direction != 0: #moviendome
		cambiar_de_estado(ESTADOS.CAMINAR)
		return
	if Input.is_action_just_pressed("w") and (is_on_floor() or puedo_usar_coyote()) and not Input.is_action_pressed("s"): #cambiar a una sola funcion q me devuelva true
		velocity.y = velocidad_salto
		cambiar_de_estado(ESTADOS.SALTAR)
	if Input.is_action_pressed("s") and Input.is_action_just_pressed("w") and is_on_floor():
		tirarse_de_plataforma()

func procesar_caminar(delta):
	velocity.x = move_toward(velocity.x, direction * velocidad, aceleracion * delta)
	animated_sprite_pj.flip_h = ultima_direccion_mirar < 0
	if direction:
		if timer_pasos <= 0 && is_on_floor():
			%FmodEventEmitter2D.play_one_shot()
			timer_pasos = timer_pasos_reset
		timer_pasos -= delta 
	if direction == 0:
		cambiar_de_estado(ESTADOS.IDLE)
		return
	if not is_on_floor():
		cambiar_de_estado(ESTADOS.CAER)
		return
	if Input.is_action_just_pressed("w") and (is_on_floor() or puedo_usar_coyote()):
		velocity.y = velocidad_salto
		cambiar_de_estado(ESTADOS.SALTAR)
	

func procesar_saltar(delta):
	if direction:
		velocity.x = move_toward(velocity.x , direction * velocidad, aceleracion * delta)
		animated_sprite_pj.flip_h = ultima_direccion_mirar < 0 #rotar pj segun para donde se mueve
	
	if Input.is_action_just_released("w") and velocity.y < 0: #probar
		velocity.y *= desaceleración_al_saltar
	
	if velocity.y >0: #TODO TESTEAR 
		cambiar_de_estado(ESTADOS.CAER)

func procesar_caer(delta):
	if direction:
		velocity.x = move_toward(velocity.x , direction * velocidad, aceleracion * delta)
		animated_sprite_pj.flip_h = ultima_direccion_mirar < 0 #rotar pj segun para donde se mueve
	
	if is_on_floor():
		if direction != 0: #moviendome
			cambiar_de_estado(ESTADOS.CAMINAR)
		else:
			cambiar_de_estado(ESTADOS.IDLE)


func procesar_agarrar(delta):
	velocity.x = move_toward(velocity.x,direction * velocidad, aceleracion * delta)
	if not agarrando_caja:
		cambiar_de_estado(ESTADOS.IDLE)


func _on_animated_sprite_pj_animation_finished() -> void:
	var animacion = animated_sprite_pj.get_animation()
	if animacion.begins_with("palanca"):
		cambiar_de_estado(ESTADOS.IDLE)
	if animacion.begins_with("salto"):
		ejecutar_animacion_caida()
	if animacion == "agarrar_oso" and estado_actual == ESTADOS.AGARRAR:
		animated_sprite_pj.play("seguir_agarrando") #TODO TESTEAR


func matar_player():
	if reviviendo_player:
		return
	reviviendo_player = true
	global_position = Global.get_checkpoint_position()
	$FmodEventEmitter2D7.play()
	reviviendo_player = false


func verificar_animacion_con_mascara():
	var animacion_actual = animated_sprite_pj.get_animation()
	#agarro la misma animacion q se estaba ejecutando pero como ahora cambio de mascara la mando a ejecutar de nuevo
	if animacion_actual.begins_with("idle"):
		ejecutar_animacion_idle()
	if animacion_actual.begins_with("palanca"):
		ejecutar_animacion_palanca()
	if animacion_actual.begins_with("caminar"):
		ejecutar_animacion_caminar()
	if animacion_actual.begins_with("salto"):
		ejecutar_animacion_saltar()
	if animacion_actual.begins_with("caida"):
		ejecutar_animacion_caida()
	if animacion_actual.begins_with("seguir"):
		ejecutar_animacion_arrastrar()

func tirarse_de_plataforma():
	position.y += 1
