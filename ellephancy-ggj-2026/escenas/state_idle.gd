extends StatePlayer

func enter():
	#super me sirve para llamar a la funcion padre desde la hereadada
	#osea llama a StatePlayer.enter (pq esta q uso se llama igual ah)
	super.enter()
	player.animated_sprite_pj.play("idle")

func transition():
	var direction : float = Input.get_axis("a", "d")
	if direction != 0:
		state_machine.cambiar_de_estado(player.caminando) #aca necesito el nodo
	if not player.is_on_floor():
		state_machine.cambiar_de_estado(player.caida)


func _physics_process(delta):
	player.velocity.x = move_toward(player.velocity.x,
		0,
		player.desaceleracion * delta
	)
