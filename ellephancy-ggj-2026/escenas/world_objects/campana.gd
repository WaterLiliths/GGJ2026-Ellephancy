class_name Campana
extends RigidBody2D

@onready var sonido_campana: FmodEventEmitter2D = $SonidoCampana

func _on_body_entered(body: Node) -> void:
	if body is Player:
		sonido_campana.play()
