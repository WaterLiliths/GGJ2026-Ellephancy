class_name AreaObjetivo
extends Area2D

@export var marker_luciernagas : Marker2D
@export var forma = CollisionShape2D
@export_enum("PUERTA", "PALANCA", "LLAVE", "POSICION")  var condiciones = "PUERTA"
@export var siguiente_objetivo : AreaObjetivo
@export_enum("PRIMERO", "INTERMEDIO", "ULTIMO") var tipo_de_objetivo = "INTERMEDIO"
@export var objeto_condicion : Node2D

var tipos_de_objeto_condicion : Array = [Puerta, Palanca, Player]

func _ready() -> void:
	Objetivos.objeto_activado.connect(_on_objeto_activado)
	if tipo_de_objetivo == "PRIMERO":
		Objetivos.objetivo_actual = self
		Objetivos.objetivo.emit(self)
	print("marker luciernagas vale: ", marker_luciernagas)

func condicion_cumplida():
	Objetivos.objetivo_completado.emit(self)
	Objetivos.objetivo_actual = siguiente_objetivo
	Objetivos.objetivo.emit(Objetivos.objetivo_actual)
	print("objetivo completado, siguiente objetivo es: ", Objetivos.objetivo_actual)

func _on_objeto_activado(objeto):
	if objeto == objeto_condicion:
		print(objeto)
		condicion_cumplida()
		return

func _on_body_entered(body: Node2D) -> void:
	if condiciones == "POSICION" and body is Player:
		condicion_cumplida()
