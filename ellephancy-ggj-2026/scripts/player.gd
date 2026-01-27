class_name Player
extends CharacterBody2D


@export var aceleracion : float = 1800.0
@export var desaceleracion : float = 2200.0
@export var velocidad_max : float = 250.0
@export var gravedad_subiendo : float = 1.0
@export var gravedad_bajando : float = 1.4
@export var velocidad : float = 250.0
@export var velocidad_salto: float = -555
@export var desaceleración_al_saltar : float = 0.5 #arreglar igual 0.5 safa
@export var desaceleracion_horizontal : float = 0.07 #ajustable a gusto
var velocidad_inicial_salto : float
var velocidad_inicial : float 
@export var velocidad_al_agarrar : float = 25
@export var velocidad_correr : float = 40
@export var fuerza_empuje : float = 0
@export var velocidad_arrastrando : float = 100.0
@onready var animated_sprite_pj: AnimatedSprite2D = %AnimatedSpritePJ
@onready var ray_cast_izq: RayCast2D = %RayCastIzq
@onready var ray_cast_der: RayCast2D = %RayCastDer

@onready var pin_joint_agarrar: PinJoint2D = %PinJointAgarrar


#probando
var objeto_arrastrado : ObjetoEmpujable = null
var esta_arrastrando : bool = false


@onready var timer_coyote_time : Timer = %TimerCoyoteTime
var estaba_en_el_piso : bool = false
@onready var mascara_tiempo: Node2D = %MascaraTiempos



func _ready() -> void:
	velocidad_inicial = velocidad
	velocidad_inicial_salto = velocidad_salto
	Global.mascara_fuerza_activa.connect(on_signal_mascara_fuerza_activa)


func _input(event: InputEvent) -> void:

	if Input.is_action_just_pressed("1"): #usar mascara tiempos
		Global.usar_mascara.emit(1)
	if Input.is_action_just_pressed("2"): #usar mascara fuerza
		Global.usar_mascara.emit(2)
	if Input.is_action_just_pressed("3"): #usar mascara traducciones
		Global.usar_mascara.emit(3)

	if Input.is_action_just_pressed("tirar") and objeto_arrastrado:
		conectar_caja_con_joint()
	if Input.is_action_just_released("tirar") and objeto_arrastrado:
		desconectar_caja_con_joint()



func _physics_process(delta: float) -> void:
	if velocity.y<0:
		velocity += get_gravity() * gravedad_subiendo * delta
	else:
		velocity += get_gravity() * gravedad_bajando * delta
	
	# salto + coyote timer
	if Input.is_action_just_pressed("w") and (is_on_floor() or puedo_usar_coyote()):
		velocity.y = velocidad_salto
		timer_coyote_time.stop()
		#TODO agregar aca animacion de salto
	if Input.is_action_just_released("w") and velocity.y < 0:
		velocity.y *= desaceleración_al_saltar
	
	#movimiento con w a s d
	var direction := Input.get_axis("a", "d")
	if direction:
		velocity.x = move_toward(velocity.x , direction * velocidad_max, aceleracion * delta)
		animated_sprite_pj.flip_h = direction < 0 #rotar pj segun para donde se mueve
		animated_sprite_pj.play("caminar")
	else:
		velocity.x = move_toward(velocity.x, 0, desaceleracion*delta)
		animated_sprite_pj.play("idle")


#	arrastrar_objeto()
	move_and_slide()

	empujar_objetos()
	comprobar_coyote_timer()
	if is_on_floor():
		timer_coyote_time.stop()
	estaba_en_el_piso = is_on_floor()


#-------------------------FUNCIONES-----------------------
func empujar_objetos() -> void: #se puede sacar ?
	if Input.is_action_pressed("tirar"):
		return
	
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var body = colision.get_collider()
	
		if body is ObjetoEmpujable:
			var direccion_empuje := -colision.get_normal()
			body.apply_central_force(direccion_empuje * fuerza_empuje)

func arrastrar_objeto() -> void:
	var direction := Input.get_axis("a", "d")
	
	if Input.is_action_pressed("tirar") and objeto_arrastrado and direction != 0:
		if not esta_arrastrando:
			esta_arrastrando = true
			pin_joint_agarrar.node_b = objeto_arrastrado.get_path()
			#objeto_arrastrado.empezar_arrastrar($AnimatedSpritePJ/MarkerTirar)
	else:
		if esta_arrastrando and objeto_arrastrado:
			objeto_arrastrado.dejar_arrastrar()
			esta_arrastrando = false

#-----------------------SEÑALES---------------------------
func _on_area_tirar_body_entered(body: Node2D) -> void:
	if body is ObjetoEmpujable:
		objeto_arrastrado = body

func conectar_caja_con_joint():
	if !%MascaraFuerza.get_estado_activa():
		print("la mascara esta desactivada, no agarrar")
		return
	pin_joint_agarrar.node_b = objeto_arrastrado.get_path()
	disminuir_velocidad_al_agarrar()

func desconectar_caja_con_joint():
	pin_joint_agarrar.node_b = self.get_path()# me vuelvo a conectar a mi mismo que es lo mismo q desconectar
	objeto_arrastrado = null
	reset_velocidad_normal()

func _on_area_tirar_body_exited(body: Node2D) -> void:
	if body == objeto_arrastrado:
		objeto_arrastrado = null


func comprobar_coyote_timer():
	if estaba_en_el_piso and not is_on_floor():#osea que recien salto
		timer_coyote_time.start()


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


func on_signal_mascara_fuerza_activa():
	pass


func desactivar_mascara_fuerza():
	pass


func disminuir_velocidad_al_agarrar():
	velocidad = velocidad_al_agarrar
	velocidad_salto = -74

func reset_velocidad_normal():
	velocidad = velocidad_inicial
	velocidad_salto = velocidad_inicial_salto
