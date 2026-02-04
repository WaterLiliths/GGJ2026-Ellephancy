extends Node2D

@onready var textura_luz: Sprite2D = %TexturaLuz


func _ready() -> void:
	%CPUParticles2D.emitting = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.set_checkpoint_position(global_position)
		$FmodEventEmitter2D.play()
		%CPUParticles2D.emitting = true
		tween_entrada()
		#tween_salida()


func tween_entrada():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(textura_luz,"modulate:a", 1.0, 1.5)

func tween_salida():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(textura_luz,"modulate:a", 0.0 , 1)
