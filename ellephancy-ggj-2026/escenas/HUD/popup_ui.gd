extends CanvasLayer


@onready var panel: Panel = %Panel
@onready var image: TextureRect = %Image
@onready var text: RichTextLabel = %Text
@onready var page_indicator: Label = %PageIndicator
@onready var prev_button: Button = %PrevButton
@onready var next_button: Button = %NextButton
@onready var close_button: Button = %CloseButton


var _imagenes: Array[Texture2D] = []
var _textos: Array[String] = []
var _current_page: int = 0

func _ready() -> void:
	Global.mostrar_popup.connect(_on_mostrar_popup)
	panel.hide()
	prev_button.pressed.connect(_on_prev)
	next_button.pressed.connect(_on_next)
	close_button.pressed.connect(_on_close)

func _on_mostrar_popup(imagenes: Array[Texture2D], textos: Array[String]) -> void:
	_imagenes = imagenes
	_textos = textos
	_current_page = 0
	get_tree().paused = true
	panel.show()
	_update_page()

func _update_page() -> void:
	image.texture = _imagenes[_current_page]

	var tiene_texto := _current_page < _textos.size() and _textos[_current_page] != ""
	text.visible = tiene_texto
	if tiene_texto:
		text.text = _textos[_current_page]

	page_indicator.text = "%d / %d" % [_current_page + 1, _imagenes.size()]
	prev_button.disabled = _current_page == 0
	next_button.disabled = _current_page == _imagenes.size() - 1

func _on_prev() -> void:
	if _current_page > 0:
		_current_page -= 1
		_update_page()

func _on_next() -> void:
	if _current_page < _imagenes.size() - 1:
		_current_page += 1
		_update_page()

func _on_close() -> void:
	panel.hide()
	get_tree().paused = false
