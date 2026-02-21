class_name MovimientoManager
extends Node


var body : Player

func setup(jugador : Player):
	body = jugador

func aplicar_gravedad(delta : float):
	if body.velocity.y<0:
		body.velocity += body.get_gravity() * body.STATS.gravedad_subiendo * delta
	else:
		body.velocity += body.get_gravity() * body.STATS.gravedad_bajando * delta
