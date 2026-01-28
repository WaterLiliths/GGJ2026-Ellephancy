class_name StateMachineManager
extends Node
#MANAGER
var estado_actual : StatePlayer
var estado_previo : StatePlayer
@export var estado_inicial : StatePlayer



func cambiar_de_estado(estado_nuevo : StatePlayer): #LE PASO EL NODO
	if estado_nuevo == estado_actual or estado_nuevo == null:
		return
	if estado_actual:
		estado_actual.exit() #primero lo saco
		estado_previo = estado_actual #lo guardo para saber en cual estaba
	estado_actual = estado_nuevo #ahora si lo cambio
	estado_actual.enter()

func _physics_process(delta):
	if estado_actual:
		estado_actual.transition() #transition verifica condiciones frame x frame 
