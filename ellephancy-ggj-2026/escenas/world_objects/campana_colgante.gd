class_name CampanaColgante
extends Node2D

const SECCION_SOGA_CAMPANA = preload("uid://j1ggk4cfsncx")
const CAMPANA = preload("uid://bnxsiuckubi5t")

@export_enum("Db", "Eb", "F", "Ab", "Bb") var nota : String = "Eb"
@onready var ancla: RigidBody2D = $Ancla
@export var longitud_soga : int = 5

var campana_colgante : Campana
var anterior: RigidBody2D


func _ready() -> void:
	anterior = ancla
	
	for n in longitud_soga:
		var soga : SeccionSoga = SECCION_SOGA_CAMPANA.instantiate()
		var joint: PinJoint2D = soga.get_node("PinJoint2D")
		self.add_child(soga)
		soga.name = "soga " + str(n)
		soga.position.y = (n + 1) * 24
		joint.node_a = soga.get_path()
		joint.node_b = anterior.get_path()
		
		anterior = soga
		if n == longitud_soga - 1:
			var campana = CAMPANA.instantiate()
			var campana_joint : PinJoint2D = campana.get_node("PinJointSoga")
			anterior.add_child(campana)
			campana.position.y = 24
			campana.sonido_campana.set_parameter("nota", nota)
			campana_joint.node_b = anterior.get_path()
			campana_joint.node_a = campana.get_path()
			campana_colgante = campana
