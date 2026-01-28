extends StatePlayer

func enter():
	super.enter()
	player.animated_sprite_pj.play("caida")

func transition():
	if player.is_on_floor():
		state_machine.cambiar_de_estado(player.idle)
