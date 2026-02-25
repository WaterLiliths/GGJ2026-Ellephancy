class_name ComponenteDeHitbox
extends Area2D

@export var componente_de_vida : ComponenteDeVida



func aplicar_daño(ataque):
	if componente_de_vida:
		componente_de_vida.recibir_daño(ataque)


func _on_area_entered(area: Area2D) -> void:
	if area is ComponenteDeHurtbox:
		aplicar_daño(area.daño)
	
