extends StatePlayer

func enter():
	super.enter()
	player.velocity.y = player.velocidad_salto
	#aca animaciond e salto pa cuando tengamos

func transition():
	# Pasar a caída cuando deja de subir
	if player.velocity.y >= 0:
		state_machine.cambiar_de_estado(player.caida)

func _physics_process(delta):
	# Movimiento en el aire
	var direction := Input.get_axis("a", "d")
	if direction != 0:
		player.velocity.x = move_toward(
			player.velocity.x,
			direction * player.velocidad,
			player.aceleracion * delta
		)
