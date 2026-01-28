extends CharacterBody2D


@export var velocidad : float = 250.0
@export var velocidad_salto: float = -555
@export var desaceleración_al_saltar : float = 0.001 #arreglar
@export var desaceleracion_horizontal : float = 0.07 #ajustable a gusto
@export var velocidad_correr : float = 40
@onready var animated_sprite_pj: AnimatedSprite2D = %AnimatedSpritePJ
<<<<<<< Updated upstream
=======
@onready var ray_cast_izq: RayCast2D = %RayCastIzq
@onready var ray_cast_der: RayCast2D = %RayCastDer

@onready var pin_joint_agarrar: PinJoint2D = %PinJointAgarrar

signal es_arrastrado
var direction

#probando
var objeto_arrastrado : ObjetoEmpujable = null
var esta_arrastrando : bool = false


>>>>>>> Stashed changes
@onready var timer_coyote_time : Timer = %TimerCoyoteTime
var estaba_en_el_piso : bool = false
var timer_pasos = 0
var timer_pasos_reset = 0.36


func _physics_process(delta: float) -> void:
	if not is_on_floor(): #gravedad
		velocity += get_gravity() * delta
	
	# salto + coyote timer
	if Input.is_action_just_pressed("w") and (is_on_floor() or timer_coyote_time.time_left > 0):
		velocity.y = velocidad_salto
		timer_coyote_time.stop()
		$FmodEventEmitter2D2.play_one_shot()
		#TODO agregar aca animacion de salto
	if Input.is_action_just_released("w") and velocity.y < 0:
		velocity.y *= desaceleración_al_saltar
	
	#movimiento con w a s d
	direction = Input.get_axis("a", "d")
	if direction:
		velocity.x = direction * velocidad
		animated_sprite_pj.flip_h = direction < 0 #rotar pj segun para donde se mueve
		animated_sprite_pj.play("caminar")
		#if animated_sprite_pj.
			#$FmodEventEmitter2D.play_one_shot()
		if timer_pasos <= 0 && is_on_floor():
			$FmodEventEmitter2D.play_one_shot()
			timer_pasos = timer_pasos_reset
		timer_pasos -= delta
	else:
		velocity.x = move_toward(velocity.x, direction * velocidad, velocidad * desaceleracion_horizontal)
		animated_sprite_pj.play("idle")

	move_and_slide()
	comprobar_coyote_timer()
	if is_on_floor():
		timer_coyote_time.stop()
	estaba_en_el_piso = is_on_floor()

<<<<<<< Updated upstream
=======

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
	if direction:
		$FmodEventEmitter2D3.play()
	#else:
		#$FmodEventEmitter2D3.stop()
	pin_joint_agarrar.node_b = objeto_arrastrado.get_path()
	disminuir_velocidad_al_agarrar()


func desconectar_caja_con_joint():
	pin_joint_agarrar.node_b = self.get_path()# me vuelvo a conectar a mi mismo que es lo mismo q desconectar
	objeto_arrastrado = null
	reset_velocidad_normal()
	$FmodEventEmitter2D3.stop()

func _on_area_tirar_body_exited(body: Node2D) -> void:
	if body == objeto_arrastrado:
		objeto_arrastrado = null


>>>>>>> Stashed changes
func comprobar_coyote_timer():
	if estaba_en_el_piso and not is_on_floor():#osea que recien salto
		timer_coyote_time.start()
