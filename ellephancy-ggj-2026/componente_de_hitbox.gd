class_name ComponenteDeHitbox
extends Area2D

@export var componente_de_vida : ComponenteDeVida


func aplicar_daño(ataque):
	if componente_de_vida:
		componente_de_vida.recibir_daño(ataque)
