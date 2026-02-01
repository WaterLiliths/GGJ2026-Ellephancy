extends CanvasLayer

#var general
var musica
var efectos
var ambiente

@onready var h_slider_musica: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSliderMusica
@onready var h_slider_2_efectos: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSlider2Efectos
@onready var h_slider_3_ambiente: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSlider3Ambiente
#@onready var h_slider_general: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSliderGeneral

@onready var boton_custom: BotonCustom = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/BotonCustom


func _ready() -> void:
	# Initial values
	h_slider_musica.value = Global.volumen_musica
	h_slider_2_efectos.value = Global.volumen_efectos
	h_slider_3_ambiente.value = Global.volumen_ambiente
	#h_slider_general.value = Global.volumen_general

	# --- SIGNAL CONNECTIONS ---
	#h_slider_general.value_changed.connect(
		#Callable(self, "_on_general_changed")
	#)
	
	h_slider_musica.value_changed.connect(
		Callable(self, "_on_musica_changed")
	)

	h_slider_2_efectos.value_changed.connect(
		Callable(self, "_on_efectos_changed")
	)

	h_slider_3_ambiente.value_changed.connect(
		Callable(self, "_on_ambiente_changed")
	)

	boton_custom.pressed.connect(
		Callable(self, "_on_boton_custom_pressed")
	)
#
#func _on_general_changed(value: float) -> void:
	#Global.volumen_general = value
	#general = value


func _on_musica_changed(value: float) -> void:
	Global.volumen_musica = value
	musica = value


func _on_efectos_changed(value: float) -> void:
	Global.volumen_efectos = value
	efectos = value


func _on_ambiente_changed(value: float) -> void:
	Global.volumen_ambiente = value
	ambiente = value


func _on_boton_custom_pressed() -> void:
	hide()

func _process(delta: float) -> void:
	print(Global.volumen_musica)
#extends CanvasLayer
#
#var musica
#var efectos
#var ambiente
#
#@onready var h_slider_musica: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSliderMusica
#@onready var h_slider_2_efectos: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSlider2Efectos
#@onready var h_slider_3_ambiente: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSlider3Ambiente
#@onready var boton_custom: BotonCustom = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/BotonCustom
#
#
#func _ready() -> void:
	#h_slider_musica.value = Global.volumen_musica
	#h_slider_2_efectos.value = Global.volumen_efectos
	#h_slider_3_ambiente.value = Global.volumen_ambiente
	#
	#h_slider_musica.drag_ended.connect(
		#Callable(self, "_on_h_slider_musica_drag_ended")
	#)
#
	#h_slider_2_efectos.drag_ended.connect(
		#Callable(self, "_on_h_slider_2_efectos_drag_ended")
	#)
#
	#h_slider_3_ambiente.drag_ended.connect(
		#Callable(self, "_on_h_slider_3_volumen_drag_ended")
	#)
#
#
#func _on_h_slider_musica_drag_ended(value_changed: bool) -> void:
	#print("Musica slider:", h_slider_musica)
	#Global.volumen_musica = h_slider_musica.value
	#musica = h_slider_musica.value
#
#
#func _on_h_slider_2_efectos_drag_ended(value_changed: bool) -> void:
	#Global.volumen_efectos = h_slider_2_efectos.value
	#efectos = h_slider_2_efectos.value
#
#
#func _on_h_slider_3_volumen_drag_ended(value_changed: bool) -> void:
	#Global.volumen_ambiente = h_slider_3_ambiente.value
	#ambiente = h_slider_3_ambiente.value
#
#
#
#func _on_boton_custom_pressed() -> void:
	#queue_free()
