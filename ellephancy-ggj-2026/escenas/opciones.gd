extends Control

var musica
var efectos
var ambiente

func _ready() -> void:
	$PanelContainer/VBoxContainer/HSliderMusica.value = Global.volumen_musica
	$PanelContainer/VBoxContainer/HSlider2Efectos.value = Global.volumen_efectos
	$PanelContainer/VBoxContainer/HSlider3Ambiente.value = Global.volumen_ambiente


func _on_h_slider_musica_drag_ended(value_changed: bool) -> void:
	Global.volumen_musica = $PanelContainer/VBoxContainer/HSliderMusica.value
	musica = $PanelContainer/VBoxContainer/HSliderMusica.value


func _on_h_slider_2_efectos_drag_ended(value_changed: bool) -> void:
	Global.volumen_efectos = $PanelContainer/VBoxContainer/HSlider2Efectos.value
	efectos = $PanelContainer/VBoxContainer/HSlider2Efectos.value


func _on_h_slider_3_volumen_drag_ended(value_changed: bool) -> void:
	Global.volumen_ambiente = $PanelContainer/VBoxContainer/HSlider3Ambiente.value
	ambiente = $PanelContainer/VBoxContainer/HSlider3Ambiente.value



func _on_boton_custom_pressed() -> void:
	queue_free()
