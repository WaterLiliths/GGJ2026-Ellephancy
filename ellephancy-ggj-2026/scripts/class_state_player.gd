class_name StatePlayer
extends Node


@onready var player : Player #se setea en ready de playe
@onready var state_machine : StateMachineManager

func _ready():
	set_physics_process(false)

func enter():
	set_physics_process(true)

func exit():
	set_physics_process(false)

func transition():
	pass
