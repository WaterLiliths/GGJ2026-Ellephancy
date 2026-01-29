class_name Palanca
extends Interactivo

var esta_encendida : bool = false
var palanca_actual : Palanca = self

@export var id : int = 0
@export var tipo_de_palanca : String = "Buen Estado"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

#-------------FUNCIONES------------------
func activar() -> void:
	esta_encendida = !esta_encendida
	if esta_encendida:
		Global.activar_palanca.emit(id)
		print("palanca activadad")
	if !esta_encendida:
		Global.desactivar_palanca.emit(id)
		print("palanca desactivada")
	$FmodEventEmitter2D.set_parameter("TipoDePalanca", tipo_de_palanca)
	$FmodEventEmitter2D.play()

#---------------SEÑALES----------------------
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entra.emit(self)
		body.on_entra_a_interactivo(palanca_actual)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_sale.emit(self)
		body.on_sale_de_interactivo(palanca_actual)
