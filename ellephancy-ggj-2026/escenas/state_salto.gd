extends StatePlayer

#func enter():
	#super.enter()
	#player.consultar_saltar()
	##aca animaciond de salto pa cuando tengamos
#
#func transition():
	#player.animated_sprite_pj.flip_h = player.direction < 0 
	#if player.is_on_floor():
		## si el jugador ya tiene input horizontal, ir a caminando
		#if Input.get_axis("a", "d") != 0:
			#state_machine.cambiar_de_estado(player.caminando)
		#else:
			#state_machine.cambiar_de_estado(player.idle)
		#return
#
#func _physics_process(delta):
	## Movimiento en el aire
	#var direction := Input.get_axis("a", "d")
	#if direction != 0:
		#player.velocity.x = move_toward(player.velocity.x,direction * player.velocidad,player.aceleracion * delta)
	#if Input.is_action_just_released("w") and player.velocity.y < 0:
		#player.velocity.y *= player.desaceleración_al_saltar
