class_name ObjetoEmpujable 
extends RigidBody2D

var densidad = 1
@onready var area

func _ready() -> void:
	area = $CollisionShape2D.global_scale.x * $CollisionShape2D.global_scale.y
	mass = 1 + (densidad * area)
	print(area)
	print("la masa de esta piedra es " + str(mass))
