class_name Palanca
extends Interactivo

var esta_encendida : bool = false
var palanca_actual : Palanca = self

@export var id : int = 0
@export_enum("buena", "oxidada", "fallada") var tipo_de_palanca : String = "buena"
@export var timeada : bool = false
@export var timer : float = 1.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$TimerPalanca.set_wait_time(timer*2.8)
	if tipo_de_palanca == "oxidada":
		modulate = Color(0.51, 0.291, 0.291, 1.0)

func _process(_delta: float) -> void:
	$FmodEventEmitter2D.volume = Global.volumen_efectos

#-------------FUNCIONES------------------
func activar() -> void:
	
	esta_encendida = !esta_encendida
	if esta_encendida and not tipo_de_palanca == "fallada":
		if timeada:
			$TimerPalanca.start()
		if tipo_de_palanca == "buena":
			$AnimationPlayer.play("activar")
			#print(tipo_de_palanca)
		else:
			$AnimationPlayer.play("activar_oxidada")
		$FmodEventEmitter2D.set_parameter("TipoDePalanca", tipo_de_palanca)
		$FmodEventEmitter2D.play()
		await $AnimationPlayer.animation_finished
		Global.activar_palanca.emit(id)
		return
	if !esta_encendida and not tipo_de_palanca == "fallada":
		if tipo_de_palanca == "buena":
			$AnimationPlayer.play("desactivar")
		else:
			$AnimationPlayer.play("desactivar_oxidada")
		$FmodEventEmitter2D.set_parameter("TipoDePalanca", tipo_de_palanca)
		$FmodEventEmitter2D.play()
		await $AnimationPlayer.animation_finished
		Global.desactivar_palanca.emit(id)
		return
	if tipo_de_palanca == "fallada":
		$AnimationPlayer.play("fallada")
		
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
	if esta_encendida and not tipo_de_palanca == "Fallada":
		esta_encendida = !esta_encendida
		$AnimationPlayer.play("desactivar")
		$FmodEventEmitter2D.play()
