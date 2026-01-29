extends StatePlayer

#var timer_pasos := 0.0
#var timer_pasos_reset := 0.36
#
#func enter():
	#super.enter()
	#player.animated_sprite_pj.play("caminar")
#
#func transition():
	#var direction : float = Input.get_axis("a", "d")
	#if direction == 0:
		#state_machine.cambiar_de_estado(player.idle)
		#return
	#if Input.is_action_just_pressed("w") and (player.is_on_floor() or player.puedo_usar_coyote()):
		#state_machine.cambiar_de_estado(player.salto)
		#return
	#if Input.is_action_just_pressed("tirar") and player.objeto_arrastrado:
		#state_machine.cambiar_de_estado(player.agarrando)
#
#func _physics_process(delta):
	#var direction := Input.get_axis("a", "d")
	#if direction:
		#player.velocity.x = move_toward(player.velocity.x , direction * player.velocidad, player.aceleracion * delta)
		#player.animated_sprite_pj.flip_h = direction < 0 #rotar pj segun para donde se mueve
		##player.animated_sprite_pj.play("caminar")
	#if player.is_on_floor():
		#if timer_pasos<0:
			#player.emitir_sonido_pasos()
			#timer_pasos = timer_pasos_reset
		#timer_pasos-= delta
