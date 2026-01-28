class_name Player
extends CharacterBody2D



@export var velocidad : float = 250.0
@export var velocidad_salto: float = -555
@export var desaceleración_al_saltar : float = 0.001 #arreglar
@export var desaceleracion_horizontal : float = 0.07 #ajustable a gusto

@export var velocidad_correr : float = 40
@export var fuerza_empuje : float = 100.0
@export var velocidad_arrastrando : float = 100.0
@onready var animated_sprite_pj: AnimatedSprite2D = %AnimatedSpritePJ

@onready var pin_joint_agarrar: PinJoint2D = %PinJointAgarrar


#probando
var objeto_arrastrado : ObjetoEmpujable = null
var esta_arrastrando : bool = false


@onready var timer_coyote_time : Timer = %TimerCoyoteTime
var estaba_en_el_piso : bool = false
@onready var mascara_tiempo: Node2D = %MascaraTiempos


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"):
		mascara_tiempo.usar() #siempre y cuando nos aseguremos que esta mascara tiene la funcion usar
		#pq si no la tiene rompemos todo wacho :(
	if Input.is_action_just_pressed("2"):
		pass
	if Input.is_action_just_pressed("3"):
		pass
	if Input.is_action_just_pressed("tirar") and objeto_arrastrado:
		conectar_caja_con_joint()
	if Input.is_action_just_released("tirar") and objeto_arrastrado:
		desconectar_caja_con_joint()



func _physics_process(delta: float) -> void:
	if not is_on_floor(): #gravedad
		velocity += get_gravity() * delta * 1.2
	
	# salto + coyote timer
	if Input.is_action_just_pressed("w") and (is_on_floor() or timer_coyote_time.time_left > 0):
		velocity.y = velocidad_salto
		timer_coyote_time.stop()
		#TODO agregar aca animacion de salto
	if Input.is_action_just_released("w") and velocity.y < 0:
		velocity.y *= desaceleración_al_saltar
	
	#movimiento con w a s d
	var direction := Input.get_axis("a", "d")
	if direction:
		velocity.x = direction * velocidad
		animated_sprite_pj.flip_h = direction < 0 #rotar pj segun para donde se mueve
		animated_sprite_pj.play("caminar")
	else:
		velocity.x = move_toward(velocity.x, direction * velocidad, velocidad * desaceleracion_horizontal)
		animated_sprite_pj.play("idle")


#	arrastrar_objeto()
	move_and_slide()

	empujar_objetos()
	comprobar_coyote_timer()
	if is_on_floor():
		timer_coyote_time.stop()
	estaba_en_el_piso = is_on_floor()


#-------------------------FUNCIONES-----------------------
func empujar_objetos() -> void: #se queda 
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
	pin_joint_agarrar.node_b = objeto_arrastrado.get_path()

func desconectar_caja_con_joint():
	pin_joint_agarrar.node_b = self.get_path()# me vuelvo a conectar a mi mismo
	objeto_arrastrado = null

func _on_area_tirar_body_exited(body: Node2D) -> void:
	if body == objeto_arrastrado:
		objeto_arrastrado = null
		#if objeto_arrastrado.es_arrastrada:
			#objeto_arrastrado.dejar_arrastrar()
		#objeto_arrastrado = null

	

func comprobar_coyote_timer():
	if estaba_en_el_piso and not is_on_floor():#osea que recien salto
		timer_coyote_time.start()
