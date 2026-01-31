extends CanvasLayer

var musica
var efectos
var ambiente

@onready var h_slider_musica: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSliderMusica
@onready var h_slider_2_efectos: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSlider2Efectos
@onready var h_slider_3_ambiente: HSlider = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HSlider3Ambiente
@onready var boton_custom: BotonCustom = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/BotonCustom


func _ready() -> void:
	h_slider_musica.value = Global.volumen_musica
	h_slider_2_efectos.value = Global.volumen_efectos
	h_slider_3_ambiente.value = Global.volumen_ambiente


func _on_h_slider_musica_drag_ended(value_changed: bool) -> void:
	Global.volumen_musica = h_slider_musica.value
	musica = h_slider_musica.value


func _on_h_slider_2_efectos_drag_ended(value_changed: bool) -> void:
	Global.volumen_efectos = h_slider_2_efectos.value
	efectos = h_slider_2_efectos.value


func _on_h_slider_3_volumen_drag_ended(value_changed: bool) -> void:
	Global.volumen_ambiente = h_slider_3_ambiente.value
	ambiente = h_slider_3_ambiente.value



func _on_boton_custom_pressed() -> void:
	queue_free()


func _on_h_slider_3_ambiente_drag_ended(value_changed: bool) -> void:
	pass # Replace with function body.
