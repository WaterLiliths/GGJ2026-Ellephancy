class_name Palanca
extends Interactivo

var esta_encendida : bool = false
var palanca_actual : Palanca = self

@export var id : int = 0
@export var tipo_de_palanca : String = "Buen Estado"
@export var timeada : bool = false
@export var timer : float = 1.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$TimerPalanca.set_wait_time(timer*2.8)

#-------------FUNCIONES------------------
func activar() -> void:
	
	esta_encendida = !esta_encendida
	if esta_encendida:
		if timeada:
			$TimerPalanca.start()
		Global.activar_palanca.emit(id)
		#print("palanca activadad")
		$AnimationPlayer.play("activar")
	if !esta_encendida:
		Global.desactivar_palanca.emit(id)
		#print("palanca desactivada")
		$AnimationPlayer.play("desactivar")
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


func _on_timer_palanca_timeout() -> void:
	if esta_encendida:
		esta_encendida = !esta_encendida
		$AnimationPlayer.play("desactivar")
		$FmodEventEmitter2D.play()
