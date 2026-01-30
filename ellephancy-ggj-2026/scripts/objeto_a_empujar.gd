class_name ObjetoEmpujable 
extends RigidBody2D

var densidad = 1
@onready var area
var estaba_en_el_piso : bool = false
var esta_en_el_aire = false

func _ready() -> void:
	area = $CollisionShape2D.global_scale.x * $CollisionShape2D.global_scale.y
	mass = 1 + (densidad * area)
	print(area)
	print("la masa de esta piedra es " + str(mass))
	#esta_en_el_aire = $RayCast2D.is_colliding()

#func _physics_process(_delta: float) -> void:
	#if velocity.y == 0
		#$FmodEventEmitter2D2.play_one_shot()
	##var esta_en_el_piso = %RayCastAbajo.is_colliding()
	##detectar_caida()
	

#func detectar_caida():
	#if esta_en_el_aire and $RayCast2D.is_colliding():
		#$FmodEventEmitter2D.play_one_shot()
