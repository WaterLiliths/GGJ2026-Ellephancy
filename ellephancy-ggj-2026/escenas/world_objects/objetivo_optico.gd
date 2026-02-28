class_name ObjetivoOptico
extends AnimatableBody2D

var siendo_cargado : bool = false
var carga : float = 0.0
var cargado : bool = false
var sonido_ejecutado : bool = false
@export var temporal : bool = false
@export var id : int = 0
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sonido_carga_completa: FmodEventEmitter2D = $FmodEventEmitter2D
@onready var sonido_cargando: FmodEventEmitter2D = $FmodEventEmitter2D2


func _physics_process(delta: float) -> void:
	
	carga = clamp(carga, 0, 100.0)
	point_light_2d.energy = carga / 10
	sonido_cargando.set_parameter("carga", carga)
	cargar()


func recibir_haz(id_haz):
	if id_haz == id and temporal:
		siendo_cargado = true
	if id_haz == id and not cargado and not temporal:
		siendo_cargado = true


func cargar():
	if cargado and not sonido_ejecutado:
		sonido_carga_completa.play()
		sonido_cargando.stop()
		carga = 100.0
		sonido_ejecutado = true
		return
	if not siendo_cargado and carga != 100.0:
		sonido_cargando.play()
		carga -= 3
		return
	carga += 0.5
	if carga >= 100.0:
		Global.activar_mecanismo.emit(self)
		cargado = true
	if temporal and not siendo_cargado:
		carga -= 3
		Global.desactivar_mecanismo.emit(self)
	siendo_cargado = false
