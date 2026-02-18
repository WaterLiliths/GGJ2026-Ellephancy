class_name ManagerDeObjetivos
extends Node

signal objetivo_completado(objetivo : AreaObjetivo)
signal objetivo
signal objeto_activado

var objetivo_actual : AreaObjetivo
var marker_luciernagas : Marker2D

func _ready():
	objetivo.connect(_es_objetivo)

func _es_objetivo(area_objetivo: AreaObjetivo):
	objetivo_actual = area_objetivo
	print("marker luciernagas es:", objetivo_actual.marker_luciernagas)
	marker_luciernagas = objetivo_actual.marker_luciernagas
	
