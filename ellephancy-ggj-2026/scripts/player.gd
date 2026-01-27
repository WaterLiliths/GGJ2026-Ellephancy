extends CharacterBody2D


@export var velocidad : float = 250.0
@export var velocidad_salto: float = -555
@export var desaceleración_al_saltar : float = 0.001 #arreglar
@export var desaceleracion_horizontal : float = 0.07 #ajustable a gusto
@export var velocidad_correr : float = 40
@onready var animated_sprite_pj: AnimatedSprite2D = %AnimatedSpritePJ
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

	move_and_slide()
	comprobar_coyote_timer()
	if is_on_floor():
		timer_coyote_time.stop()
	estaba_en_el_piso = is_on_floor()

func comprobar_coyote_timer():
	if estaba_en_el_piso and not is_on_floor():#osea que recien salto
		timer_coyote_time.start()
