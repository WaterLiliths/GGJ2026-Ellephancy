class_name AgarrarManager
extends Node

var objeto_empujable : Empujable = null
var agarrando : bool = false

@onready var ray_cast_izq: RayCast2D = %RayCastIzq #se usan para las "manos"
@onready var ray_cast_der: RayCast2D = %RayCastDer
signal resetear_velocidad_normal
#--------------"MANOS" PARA EVITAR TRABARSE CON LA CAJA---------------
@onready var mano_test_izq: CollisionShape2D = %CollisionManoIzq
@onready var mano_test_der: CollisionShape2D = %CollisionManoDer

@export var body : Player
@export var STATS : PlayerStats
@export var mov_manager : MovimientoManager
@export var animation_manager : AnimationManager
@export var sound_manager : SoundManager


func _ready() -> void:
	mano_test_izq.set_deferred("disabled", true) #DESACTIVO FISICAS DE LA MANO
	mano_test_der.set_deferred("disabled", true)


#------------------ SEÑALES BODY ENTERED ------------
func _on_area_tirar_body_entered(body: Node2D) -> void: #cuando me acerco a la caja
	if body is Empujable:
		objeto_empujable = body


func _on_area_tirar_body_exited(body: Node2D) -> void: #cuando me alejo de la caja
	if body is Empujable:
		soltar_caja()
		objeto_empujable = null

#---------- SEÑAL DE APRETE TECLA PARA TIRAR/EMPUJAR ---- DESDE INPUT MANAGER ----------
func _on_input_manager_tirar_presionado() -> void:
	if Global.mascara_activa != 2:
		return
	if not objeto_empujable:
		return
	if agarrando:
		soltar_caja()
	else:
		agarrar_caja()


func soltar_caja():
	if not agarrando:
		return
	sound_manager.detener_sonido_arrastrar() #solo POR LAS DUDAS
	objeto_empujable.siendo_agarrada = false
	resetear_velocidad_normal.emit()
	mov_manager.cambiar_de_estado(body.ESTADOS.IDLE)
	agarrando = false
	activar_mano()



func disminuir_velocidad_al_agarrar():
	STATS.velocidad = STATS.velocidad_arrastrando




func activar_mano(): #TODAVIA ES NECESARIO, SE SIGUE QUEDANDO ATASCADO
	if agarrando:
		return
	ray_cast_izq.force_raycast_update()
	ray_cast_der.force_raycast_update()
	if ray_cast_izq.is_colliding() and ray_cast_der.is_colliding(): #ahi me aseguro que esta "encerrado" y solo en ese caso q active la mano
		mano_test_izq.set_deferred("disabled", false) #ACTIVO FISICAS DE LA MANO
		mano_test_der.set_deferred("disabled", false) #ACTIVO FISICAS DE LA MANO
		await get_tree().create_timer(0.1).timeout
		mano_test_izq.set_deferred("disabled", true) #y aca las vuelvo a desactivar
		mano_test_der.set_deferred("disabled", true)


func agarrar_caja():
	print("se ejecuta agarrar caja................................")
	if not body.is_on_floor():
		return
	var direccion_con_caja = sign(body.global_position.x- objeto_empujable.global_position.x)
	#direccion -1 es esta a tu derecha, 1 es que esta a tu izquierda
	if body.ultima_direccion_mirar == direccion_con_caja: #aunque diga == significa que son direcciones opuestas
		print("NO AGARRAR, ESTAS MIRANDO OPUESTO A LA CAJA")
		return
	disminuir_velocidad_al_agarrar()
	mov_manager.cambiar_de_estado(body.ESTADOS.AGARRAR)
	print("en teoria deberia cambiar de estado a agarrar")
	body.animacion_agarrar_inicial_terminada = false
	animation_manager.ejecutar_animacion_arrastrar()
	agarrando = true
