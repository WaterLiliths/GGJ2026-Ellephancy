extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		#print("player entro al area de reverb")
		%FmodEventEmitter2D.play()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		%FmodEventEmitter2D.stop()
