extends StatePlayer

func enter():
	#super me sirve para llamar a la funcion padre desde la hereadada
	#osea llama a StatePlayer.enter (pq esta q uso se llama igual ah)
	super.enter()
	player.animated_sprite_pj.play("idle_prueba")

func transition():
	var direction : float = Input.get_axis("a", "d")
	if direction != 0:
		state_machine.cambiar_de_estado(player.caminando)
		return
	if Input.is_action_just_pressed("w") and (player.is_on_floor() or player.puedo_usar_coyote()):
		state_machine.cambiar_de_estado(player.salto)
		return
	if Input.is_action_just_pressed("tirar") and player.objeto_arrastrado: #arreglar, agarra aunque no tenga mascara
		state_machine.cambiar_de_estado(player.agarrando)


func _physics_process(delta):
	player.velocity.x = move_toward(player.velocity.x,0,player.desaceleracion * delta)
