class_name Palanca
extends Interactivo

var esta_encendida : bool = false
var palanca_actual : Palanca = self
@onready var luz_verde: PointLight2D = %PointLigVerde


@export var id : int = 0
@export_enum("buena", "oxidada", "fallada", "runas") var tipo_de_palanca : String = "buena"
@export var timeada : bool = false
@export var timer : float = 1.0
@export var usa_runas : bool = false
@onready var runa: Runa = $Runa
var color : Color

signal palanca_con_runa_activada(palanca, id, runa)


func _ready() -> void:
	if usa_runas:
		runa.asignar_tipo(runa.TiposDeRunas.values().pick_random(), color)
		runa.show()
		tipo_de_palanca = "runas"
		emitir_señal()
		
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$TimerPalanca.set_wait_time(timer)
	tween_salida_luz_verde()
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
		match tipo_de_palanca:
			"buena":
				$AnimationPlayer.play("activar")
				$FmodEventEmitter2D.set_parameter("TipoDePalanca", tipo_de_palanca)
				$FmodEventEmitter2D.play()
				await $AnimationPlayer.animation_finished
			"oxidada":
				$AnimationPlayer.play("activar_oxidada")
				$FmodEventEmitter2D.set_parameter("TipoDePalanca", tipo_de_palanca)
				$FmodEventEmitter2D.play()
				await $AnimationPlayer.animation_finished
			"runas":
				$AnimationPlayer.play("runas")
				$FmodEventEmitter2D.set_parameter("TipoDePalanca", tipo_de_palanca)
				$FmodEventEmitter2D.play()
				await get_tree().create_timer(0.5).timeout
		emitir_señal()
		tween_entrada_luz_verde()
		return
	if !esta_encendida and not tipo_de_palanca == "fallada":
		match tipo_de_palanca:
			"buena":
				$AnimationPlayer.play("desactivar")
				$FmodEventEmitter2D.set_parameter("TipoDePalanca", tipo_de_palanca)
				$FmodEventEmitter2D.play()
				await $AnimationPlayer.animation_finished
			"oxidada":
				$AnimationPlayer.play("desactivar_oxidada")
				$FmodEventEmitter2D.set_parameter("TipoDePalanca", tipo_de_palanca)
				$FmodEventEmitter2D.play()
				await $AnimationPlayer.animation_finished
			"runas":
				$AnimationPlayer.play("runas")
				$FmodEventEmitter2D.set_parameter("TipoDePalanca", tipo_de_palanca)
				$FmodEventEmitter2D.play()
				await get_tree().create_timer(0.5).timeout
		emitir_señal()
		tween_salida_luz_verde()
		return
	if tipo_de_palanca == "fallada":
		$AnimationPlayer.play("fallada")


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

func emitir_señal():
	if usa_runas:
		cambiar_de_runa()
		palanca_con_runa_activada.emit(self, id, runa)
	else:
		Global.activar_palanca.emit(id)

func tween_entrada_luz_verde():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(luz_verde,"energy", 6, 0.5)
	tween.tween_property(luz_verde,"energy", 4, 0.5)

func tween_salida_luz_verde():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(luz_verde,"energy", 0.0 , 0.8)

func cambiar_de_runa():
	var nueva_runa = (runa.TiposDeRunas.values().find(runa.tipo_de_runa) + 1) % runa.TiposDeRunas.size()
	runa.asignar_tipo(nueva_runa, color)
	
