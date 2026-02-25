class_name ComponenteDeHurtbox
extends Area2D

@export var daño : int

func _on_area_entered(area: Area2D) -> void:
	if area is ComponenteDeHitbox:
		area.aplicar_daño(daño)
