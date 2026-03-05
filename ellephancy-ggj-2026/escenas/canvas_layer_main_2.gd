extends CanvasLayer

var resolucion_default = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())

@onready var h_slider_musica: HSlider = %HSliderMusica
@onready var h_slider_2_efectos: HSlider = %HSlider2Efectos
@onready var h_slider_3_ambiente: HSlider = %HSlider3Ambiente
@onready var cerrar: BotonCustom = %Cerrar


func _ready() -> void:
	#setup_sliders_y_botones()
	pass


func setup_sliders_y_botones():
	#si te tira un error aca poner un return
	#igual hay que arreglarlo
	h_slider_musica.value = Global.volumen_musica
	h_slider_2_efectos.value = Global.volumen_efectos
	h_slider_3_ambiente.value = Global.volumen_ambiente
	
	h_slider_musica.value_changed.connect(
		Callable(self, "_on_musica_changed")
	)

	h_slider_2_efectos.value_changed.connect(
		Callable(self, "_on_efectos_changed")
	)

	h_slider_3_ambiente.value_changed.connect(
		Callable(self, "_on_ambiente_changed")
	)

	cerrar.pressed.connect(
		Callable(self, "_on_boton_custom_pressed")
	)

func _on_musica_changed(value: float) -> void:
	Global.volumen_musica = value
	Global.cambiar_volumen.emit()
	h_slider_musica.value = value


func _on_efectos_changed(value: float) -> void:
	Global.volumen_efectos = value
	Global.cambiar_volumen.emit()
	h_slider_2_efectos.value = value


func _on_ambiente_changed(value: float) -> void:
	Global.volumen_ambiente = value
	Global.cambiar_volumen.emit()
	h_slider_3_ambiente.value = value


func _on_boton_custom_pressed() -> void:
	hide()


func _on_tipo_de_ventana_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)


func _on_resolucion_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(3240, 2160))
		1:
			DisplayServer.window_set_size(Vector2i(2560, 1440))
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		3:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		4:
			DisplayServer.window_set_size(Vector2i(1366, 768))
		5:
			DisplayServer.window_set_size(Vector2i(1280, 720))


func _on_vsync_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		2:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
