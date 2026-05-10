extends RichTextLabel

var _tween: Tween

func _ready() -> void:
	modulate.a = 0.0
	Global.nombre_zona.connect(_on_nombre_zona)

func _on_nombre_zona(nombre: String) -> void:
	text = nombre
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", 1.0, 0.4)
	_tween.tween_interval(2.0)
	_tween.tween_property(self, "modulate:a", 0.0, 0.6)
