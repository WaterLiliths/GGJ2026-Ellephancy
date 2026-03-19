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
@export var posicionador_de_runa : Marker2D
@onready var runa: Runa = $Runa
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var color : Color

signal palanca_con_runa_activada(palanca, runa)

 
func _ready() -> void:
	Global.mascara_traducciones_activa.connect(mostrar_runas)
	Global.mascara_traducciones_desactivar.connect(esconder_runas)
	runa.hide()
	if usa_runas:
		setup_runas()
		
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
	esta_encendida = !esta_encendida #para que se ejecute 
	if esta_encendida and not tipo_de_palanca == "fallada":
		if timeada:
			$TimerPalanca.start()
		match tipo_de_palanca:
			"buena":
				reproducir_animacion("activar")
				await $AnimationPlayer.animation_finished
			"oxidada":
				reproducir_animacion("activar")
				await $AnimationPlayer.animation_finished
			"runas":
				reproducir_animacion("activar")
				await get_tree().create_timer(0.5).timeout
		emitir_señal(true)
		tween_entrada_luz_verde()
		return
	if !esta_encendida and not tipo_de_palanca == "fallada":
		match tipo_de_palanca:
			"buena":
				reproducir_animacion("desactivar")
				await $AnimationPlayer.animation_finished
			"oxidada":
				reproducir_animacion("desactivar")
				await $AnimationPlayer.animation_finished
			"runas":
				reproducir_animacion("activar")
				await get_tree().create_timer(0.5).timeout
		emitir_señal(false)
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

func reproducir_animacion(activar: String, cargando_datos : bool = false):
	if animation_player.is_playing():
		animation_player.stop()
	
	animation_player.play(activar + "_" + tipo_de_palanca)
	if not cargando_datos:
		#solo ejecutar sonido cuando se activa de verdad
		$FmodEventEmitter2D.set_parameter("TipoDePalanca", tipo_de_palanca)
		$FmodEventEmitter2D.play()
	else:
		#si estoy cargando datos directamente salteo la animacion al final
		var duracion_anim = animation_player.get_animation(activar + "_" + tipo_de_palanca).length
		print("la duracion vale : ", duracion_anim)
		animation_player.seek(duracion_anim, true) #para adelantar la animacion al final
		animation_player.play(activar + "_" + tipo_de_palanca + "_"  +"estatico")


func emitir_señal(activar: bool):
	if activar:
		if usa_runas:
			cambiar_de_runa()
			palanca_con_runa_activada.emit(self, runa)
		else:
			Global.activar_mecanismo.emit(self)
	else:
		Global.desactivar_mecanismo.emit(self)


func tween_entrada_luz_verde():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(luz_verde,"energy", 6, 0.5)
	tween.tween_property(luz_verde,"energy", 4, 0.5)

func tween_salida_luz_verde():
	if not usa_runas:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(luz_verde,"energy", 0.0 , 0.8)

func cambiar_de_runa():
	var nueva_runa = (runa.TiposDeRunas.values().find(runa.tipo_de_runa) + 1) % runa.TiposDeRunas.size()
	luz_verde.color = color
	runa.asignar_tipo(nueva_runa, color)
	
func mostrar_runas():
	luz_verde.show()

func esconder_runas():
	luz_verde.hide()

func setup_runas():
	runa.asignar_tipo(runa.TiposDeRunas.values().pick_random(), color)
	runa.show()
	tipo_de_palanca = "runas"
	if posicionador_de_runa:
		runa.position = posicionador_de_runa.position - runa.size / 2 * runa.scale
		runa.rotation = posicionador_de_runa.rotation
		
	emitir_señal(true)

#----------------------------- GUARDAR Y CARGAR -------------------------

#se llaman en global con get_tree().call_group("persistente", "guardar") y para cargar igual
func guardar():
	#print("##### Objeto guardado con la key: ", get_path())
	Global.diccionario_persistentes[get_path()] = {"esta_encendida" = esta_encendida} #guardo con un diccionario adentro de otro


func cargar():
	#print("-- se ejecuto cargar en el objeto empujable  : ", get_path())
	if Global.diccionario_persistentes.has(get_path()):
		#print("-------  ENCONTRE MI KEY EN EL DICCIONARIOOOOO ")
		esta_encendida = Global.diccionario_persistentes[get_path()]["esta_encendida"]
		simular_activacion()
	else:
		guardar() #si por algun motivo no se habia guardado anteriormente, lo guardo con la posicion actual
		#print("ATENCION ----- NO SE ENCONTRO MI INFO EN EL DICCIONARIO ")



func simular_activacion(): #simulamos el estado activo / inactivo pero sin emitir sonidos ni emitir señales
	#la idea es q sea solamente visual y al momento de cargar datos
	if not esta_encendida:
		#la palanca ya viene con esta variable en false, si se da ese caso no hacer nada
		return
	if esta_encendida and not tipo_de_palanca == "fallada":
		#if timeada:
			#$TimerPalanca.start()
		match tipo_de_palanca:
			"buena":
				reproducir_animacion("activar", true)
				#await $AnimationPlayer.animation_finished
			"oxidada":
				reproducir_animacion("activar", true)
				#await $AnimationPlayer.animation_finished
			"runas":
				reproducir_animacion("activar", true)
				#await get_tree().create_timer(0.5).timeout
		#emitir_señal(true)
		tween_entrada_luz_verde()
		return
	if !esta_encendida and not tipo_de_palanca == "fallada":
		match tipo_de_palanca:
			"buena":
				reproducir_animacion("desactivar", true)
				await $AnimationPlayer.animation_finished
			"oxidada":
				reproducir_animacion("desactivar", true)
				await $AnimationPlayer.animation_finished
			"runas":
				reproducir_animacion("activar", true)
				await get_tree().create_timer(0.5).timeout
		#emitir_señal(false)
		tween_salida_luz_verde()
		return
	if tipo_de_palanca == "fallada":
		$AnimationPlayer.play("fallada")
