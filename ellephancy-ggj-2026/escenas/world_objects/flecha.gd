class_name Flecha
extends RigidBody2D

@export var componente_de_hurtbox : ComponenteDeHurtbox
@export var daño : int = 20

func _ready() -> void:
	componente_de_hurtbox.daño = daño


func _physics_process(delta: float) -> void:
	global_rotation = Vector2.LEFT.angle_to(linear_velocity)
	if get_contact_count() > 0:
		queue_free()


#
#func _on_componente_de_hurtbox_area_entered(area: Area2D) -> void:
	#if area is ComponenteDeHitbox:
		#queue_free()
