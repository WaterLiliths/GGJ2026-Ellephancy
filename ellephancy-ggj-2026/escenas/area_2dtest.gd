extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%LabelTESTMSJ.hide()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		%LabelTESTMSJ.show()


func _on_label_testmsj_mouse_exited() -> void:
	%LabelTESTMSJ.hide()
