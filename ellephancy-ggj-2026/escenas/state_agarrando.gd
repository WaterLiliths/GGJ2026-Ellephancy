extends StatePlayer

func enter():
	super.enter()
	if player.objeto_arrastrado:
		player.conectar_caja_con_joint()

func _physics_process(delta):
	var direction := Input.get_axis("a", "d")
	if direction != 0:
		player.velocity.x = move_toward(player.velocity.x, direction * player.velocidad_al_agarrar, player.aceleracion * delta)
		player.animated_sprite_pj.flip_h = direction < 0 #dsp sacar si queremos q solo arrastre mirando de un lado
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.desaceleracion * delta)

func transition():
	# si suelta la tecla de tirar o no hay caja, volver a idle
	if not Input.is_action_pressed("tirar") or not player.objeto_arrastrado:
		# desconectar caja en Player
		player.desconectar_caja_con_joint()
		state_machine.cambiar_de_estado(player.idle)
		return
