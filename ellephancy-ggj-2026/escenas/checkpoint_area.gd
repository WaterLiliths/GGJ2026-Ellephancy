extends Node2D


func _ready() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.set_checkpoint_position(global_position)
		$FmodEventEmitter2D.play()
