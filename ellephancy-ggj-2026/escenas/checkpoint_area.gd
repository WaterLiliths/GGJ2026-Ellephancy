extends Node2D

@onready var textura_luz: Sprite2D = %TexturaLuz
@onready var animation_checkpoint: AnimationPlayer = %AnimationCheckpoint
var checkpoint_activo : bool = false

func _ready() -> void:
	%CPUParticles2D.emitting = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player: 
		Global.set_checkpoint_position(global_position)
		$FmodEventEmitter2D.play()
		if not checkpoint_activo: #checkpoint activo es nuevo, podriamos usarlo tambien para que se desactive cuando activo otro
			%CPUParticles2D.emitting = true
			animation_checkpoint.play("entrada_luz")
		checkpoint_activo = true
		#tween_entrada()
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


func _on_animation_checkpoint_animation_finished(anim_name: StringName) -> void:
	if anim_name == "entrada_luz":
		animation_checkpoint.play("luz_encendida")
