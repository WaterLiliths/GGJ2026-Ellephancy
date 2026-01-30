extends Control

@export var volumen_maximo : float = 1

func _ready() -> void:
	$FmodEventEmitter2D.play()
	$FmodEventEmitter2D.volume = 0.0
	$ColorRect2.visible = true
	var tween = create_tween()
	var tween_audio = create_tween()
	tween_audio.tween_property($FmodEventEmitter2D, "volume", volumen_maximo, 8).set_trans(Tween.TRANS_SINE)
	tween.tween_property($ColorRect2, "color", Color(0,0,0,0), 5)

func _physics_process(delta: float) -> void:
	$RichTextLabel.position.y -= 40 * delta
