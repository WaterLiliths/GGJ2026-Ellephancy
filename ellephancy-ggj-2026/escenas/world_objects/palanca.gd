class_name Palanca
extends Interactivo


var esta_encendida : bool = false
var palanca_actual : Palanca = self

@export var id : int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

#-------------FUNCIONES------------------
func activar() -> void:
	esta_encendida = !esta_encendida
	
	if esta_encendida:
		Global.usar_palanca.emit(id)
		print("palanca activada")
	else:
		
		print("palanca desactivada")

#---------------SEÑALES----------------------
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entra.emit(self)
		body.on_entra_a_interactivo(palanca_actual)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_sale.emit(self)
		body.on_sale_de_interactivo(palanca_actual)
