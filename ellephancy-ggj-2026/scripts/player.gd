class_name Player
extends CharacterBody2D

#---------- mascaras -----------
@onready var mascara_tiempos: Node2D = %MascaraTiempos
@onready var mascara_fuerza: Node2D = %MascaraFuerza
@onready var mascara_traducciones: Node2D = %MascaraTraducciones
#-------------------------------
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

func _ready() -> void:
	timer_tiempo_en_aire.wait_time = tiempo_maximo_en_aire
	velocidad_inicial = velocidad
	velocidad_inicial_salto = velocidad_salto
	Global.mascara_fuerza_activa.connect(activar_mascara_fuerza)
	Global.mascara_fuerza_desactivar.connect(desactivar_mascara_fuerza)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"): #usar mascara tiempos
		mascara_tiempo.usar()
		mascara_fuerza.desactivar()
		mascara_traducciones.desactivar()
	if Input.is_action_just_pressed("2"): #usar mascara fuerza
		mascara_tiempo.desactivar()
		mascara_fuerza.usar()
		mascara_traducciones.desactivar()
	if Input.is_action_just_pressed("3"): #usar mascara traducciones
		mascara_tiempo.desactivar()
		mascara_fuerza.desactivar()
		mascara_traducciones.usar()

	if Input.is_action_just_pressed("tirar") and objeto_arrastrado and Global.mascara_activa==2:
		conectar_caja_con_joint()
	if Input.is_action_just_released("tirar"): # TODO 
		desconectar_caja_con_joint()



func _physics_process(delta: float) -> void:
	direction = Input.get_axis("a", "d")
	aplicar_gravedad(delta)
	
	# -------------------- salto + coyote timer  -------------------------------
	if Input.is_action_just_pressed("w") and (is_on_floor() or puedo_usar_coyote()):
		velocity.y = velocidad_salto
		timer_coyote_time.stop()
		$FmodEventEmitter2D2.play_one_shot()
		animated_sprite_pj.play("salto-final")
	if Input.is_action_just_released("w") and velocity.y < 0:
		velocity.y *= desaceleración_al_saltar
	
	movimiento_wasd(delta)
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

	if is_on_floor():
		timer_coyote_time.stop()
	emitir_sonido_caida()
	estaba_en_el_piso = is_on_floor()
	if not sonido_caida_emitiendo: 
		emitir_sonido_caida()
		#------------------------INTERACTUAR------------------------
	if puede_interactuar and objeto_interactivo is Palanca and Input.is_action_just_pressed("interactuar"):
		objeto_interactivo.activar()


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


func desconectar_caja_con_joint():
	pin_joint_agarrar.node_b = self.get_path()# me vuelvo a conectar a mi mismo que es lo mismo q desconectar
	objeto_arrastrado = null
	reset_velocidad_normal()
	agarrando_caja = false
	%FmodEventEmitter2D3.stop()


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
	print((1 / objeto_arrastrado.mass))
	print("la velocidad de movimiento es: " + str(velocidad))
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
		animated_sprite_pj.play("salto-final")
		$FmodEventEmitter2D5.play()
		sonido_caida_emitiendo = true


func aplicar_gravedad(delta : float):
	if velocity.y<0:
		velocity += get_gravity() * gravedad_subiendo * delta
	else:
		velocity += get_gravity() * gravedad_bajando * delta


func movimiento_wasd(delta : float):
	if direction:
		velocity.x = move_toward(velocity.x , direction * velocidad, aceleracion * delta)
		animated_sprite_pj.flip_h = direction < 0 #rotar pj segun para donde se mueve
		if is_on_floor():
			animated_sprite_pj.play("caminar_prueba")
		
		if timer_pasos <= 0 && is_on_floor():
			%FmodEventEmitter2D.play_one_shot()
			timer_pasos = timer_pasos_reset
		timer_pasos -= delta
	else:
		velocity.x = move_toward(velocity.x, 0, desaceleracion*delta)
		animated_sprite_pj.play("idle_prueba")
