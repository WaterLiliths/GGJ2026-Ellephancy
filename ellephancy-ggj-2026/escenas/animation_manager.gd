class_name AnimationManager
extends Node

@export var player : Player
@export var sound_manager : SoundManager
@export var mascaras_manager : MascarasManager
@export var input_manager : InputManager
@export var estados_manager : EstadosManager
@export var animated_sprite_pj : AnimatedSprite2D

func verificar_animacion_con_mascara():
	var animacion_actual = animated_sprite_pj.get_animation()
	#agarro la misma animacion q se estaba ejecutando pero como ahora cambio de mascara la mando a ejecutar de nuevo
	if animacion_actual.begins_with("idle"):
		ejecutar_animacion_idle()
	if animacion_actual.begins_with("palanca"):
		ejecutar_animacion_palanca()
	if animacion_actual.begins_with("caminar"):
		ejecutar_animacion_caminar()
	if animacion_actual.begins_with("salto"):
		ejecutar_animacion_saltar()
	if animacion_actual.begins_with("caida"):
		ejecutar_animacion_caida()
	if animacion_actual.begins_with("seguir"):
		ejecutar_animacion_arrastrar()


func ejecutar_animacion_caminar(forzar_id : int = 0): #por si queremos forzar una especifica
	match Global.mascara_activa:
		0:
			animated_sprite_pj.play("caminar_normal")
		1:
			animated_sprite_pj.play("caminar_ciervo")
		2:
			animated_sprite_pj.play("caminar_oso")
		3:
			animated_sprite_pj.play("caminar_salmon")


func ejecutar_animacion_saltar(forzar_id : int = 0): #por si queremos forzar una especifica
	match Global.mascara_activa:
		0:
			animated_sprite_pj.play("salto-normal")
		1:
			animated_sprite_pj.play("salto_ciervo")
		2:
			animated_sprite_pj.play("salto_oso")
		3:
			animated_sprite_pj.play("salto_salmon")


func ejecutar_animacion_arrastrar(): #solo puede el oso
	animated_sprite_pj.play("seguir_agarrando")


func ejecutar_animacion_palanca(forzar_id : int = 0): #por si queremos forzar una especifica
	match Global.mascara_activa:
		0:
			animated_sprite_pj.play("palanca_normal")
		1:
			animated_sprite_pj.play("palanca_ciervo")
		2:
			animated_sprite_pj.play("palanca_oso")
		3:
			animated_sprite_pj.play("palanca_salmon")


func ejecutar_animacion_idle(forzar_id : int = 0): #por si queremos forzar una especifica
	match Global.mascara_activa:
		0:
			animated_sprite_pj.play("idle_normal")
		1:
			animated_sprite_pj.play("idle_ciervo")
		2:
			animated_sprite_pj.play("idle_oso")
		3:
			animated_sprite_pj.play("idle_salmon")


func ejecutar_animacion_caida(forzar_id : int = 0): #por si queremos forzar una especifica
	match Global.mascara_activa:
		0:
			animated_sprite_pj.play("caida_normal")
		1:
			animated_sprite_pj.play("caida_ciervo")
		2:
			animated_sprite_pj.play("caida_oso")
		3:
			animated_sprite_pj.play("caida_salmon")


func _on_animated_sprite_pj_animation_finished() -> void:
	var animacion = animated_sprite_pj.get_animation()
	if animacion.begins_with("palanca"):
		player.cambiar_de_estado(player.ESTADOS.IDLE)
	if animacion.begins_with("salto"):
		ejecutar_animacion_caida()
	if animacion == "agarrar_oso" and estados_manager.estado_actual == estados_manager.ESTADOS.AGARRAR:
		player.animacion_agarrar_inicial_terminada = true
