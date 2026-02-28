class_name CampanaColgante
extends Node2D

const SECCION_SOGA_CAMPANA = preload("uid://j1ggk4cfsncx")
const CAMPANA = preload("uid://bnxsiuckubi5t")

@export_enum("Db", "Eb", "F", "Ab", "Bb") var nota : String = "Eb"
@onready var ancla: RigidBody2D = $Ancla
@export var longitud_soga : int = 5
@export var motor : bool = false
@export var rango_de_movimiento : float = 0
var primera_soga :SeccionSoga

var campana_colgante : Campana
var anterior: RigidBody2D
var tween_motor = create_tween()

func _ready() -> void:
	anterior = ancla
	for n in longitud_soga:
		var soga : SeccionSoga = SECCION_SOGA_CAMPANA.instantiate()
		var joint: PinJoint2D = soga.get_node("PinJoint2D")
		self.add_child(soga)
		soga.name = "soga " + str(n)
		soga.position.y = (n + 1) * 20
		joint.node_a = soga.get_path()
		joint.node_b = anterior.get_path()
		anterior = soga
		
		if n == 0 and motor:
			soga.freeze = true
			primera_soga = soga

		if n == longitud_soga - 1:
			var campana = CAMPANA.instantiate()
			var campana_joint : PinJoint2D = campana.get_node("PinJointSoga")
			self.add_child(campana)
			campana.position.y = (n + 2) * 20
			campana.sonido_campana.set_parameter("nota", nota)
			campana_joint.node_a = campana.get_path()
			campana_joint.node_b = anterior.get_path()
			campana_colgante = campana

func _physics_process(delta: float) -> void:
	if motor:
		tween_motor.set_trans(Tween.TRANS_SINE)
		tween_motor.tween_property(primera_soga, "position:x", 30, 1.2)
		tween_motor.tween_property(primera_soga, "position:x", -30, 1.2)
