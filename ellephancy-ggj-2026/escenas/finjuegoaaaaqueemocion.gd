extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		terminar_juego_omg_voy_a_llorar()


func terminar_juego_omg_voy_a_llorar():
	print("omg")
