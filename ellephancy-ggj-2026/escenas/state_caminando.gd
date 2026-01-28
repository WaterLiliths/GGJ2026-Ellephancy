extends StatePlayer

func enter():
	super.enter()
	player.animated_sprite_pj.play("caminar")

func transition():
	var direction : float = Input.get_axis("a", "d")
	if direction == 0:
		state_machine.cambiar_de_estado(player.idle)
		return
	
	if not player.is_on_floor():
		state_machine.cambiar_de_estado(player.caida)


func _physics_process(delta):
	var direction := Input.get_axis("a", "d")
	if direction:
		player.velocity.x = move_toward(player.velocity.x , direction * player.velocidad, player.aceleracion * delta)
		player.animated_sprite_pj.flip_h = direction < 0 #rotar pj segun para donde se mueve
		#player.animated_sprite_pj.play("caminar")
