class_name Player
extends CharacterBody2D

@export var velocidad : float = 200
@export var velocidad_salto: float = -500
@export var velocidad_correr : float = 40
@export var fuerza_empuje : float = 100.0
@export var velocidad_arrastrando : float = 100.0
@onready var animated_sprite_pj: AnimatedSprite2D = %AnimatedSpritePJ

var objeto_arrastrado : ObjetoEmpujable = null
var esta_arrastrando : bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor(): #gravedad
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("w") and is_on_floor():
		velocity.y = velocidad_salto
		#TODO agregar aca animacion de salto

	#movimiento con w a s d
	var direction := Input.get_axis("a", "d")
	if direction:
		if esta_arrastrando:
			velocity.x = direction * velocidad_arrastrando
			animated_sprite_pj.play("caminar")
		else:
			velocity.x = direction * velocidad
			animated_sprite_pj.play("caminar")
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
		animated_sprite_pj.play("idle")

	arrastrar_objeto()
	move_and_slide()
	empujar_objetos()


#-------------------------FUNCIONES-----------------------
func empujar_objetos() -> void:
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
			objeto_arrastrado.empezar_arrastrar($AnimatedSpritePJ/MarkerTirar)
	else:
		if esta_arrastrando and objeto_arrastrado:
			objeto_arrastrado.dejar_arrastrar()
			esta_arrastrando = false

#-----------------------SEÑALES---------------------------
func _on_area_tirar_body_entered(body: Node2D) -> void:
	if body is ObjetoEmpujable:
		objeto_arrastrado = body



func _on_area_tirar_body_exited(body: Node2D) -> void:
	if body == objeto_arrastrado:
		if objeto_arrastrado.es_arrastrada:
			objeto_arrastrado.dejar_arrastrar()
		objeto_arrastrado = null
