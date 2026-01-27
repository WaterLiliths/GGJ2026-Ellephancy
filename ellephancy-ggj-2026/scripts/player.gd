extends CharacterBody2D


@export var velocidad : float = 200
@export var velocidad_salto: float = -500
@export var velocidad_correr : float = 40
@onready var animated_sprite_pj: AnimatedSprite2D = %AnimatedSpritePJ


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
		velocity.x = direction * velocidad
		animated_sprite_pj.play("caminar")
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
		animated_sprite_pj.play("idle")

	move_and_slide()
