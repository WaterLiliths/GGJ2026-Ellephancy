class_name ObjetivoOptico
extends AnimatableBody2D

var siendo_cargado : bool = false
var carga : float = 0.0
var cargado : bool = false
var activo : bool = false
var sonido_cargando_activo : bool = false

@export var temporal : bool = false
@export var id : int = 0

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var sonido_carga_completa: FmodEventEmitter2D = $FmodEventEmitter2D
@onready var sonido_cargando: FmodEventEmitter2D = $FmodEventEmitter2D2

func _physics_process(_delta: float) -> void:
	carga = clamp(carga, 0.0, 100.0)
	point_light_2d.energy = carga / 10.0
	sonido_cargando.set_parameter("carga", carga)
	cargar()
	siendo_cargado = false

func recibir_haz(id_haz):
	if id_haz == id and temporal:
		siendo_cargado = true
	if id_haz == id and not cargado and not temporal:
		siendo_cargado = true

func cargar():
	if siendo_cargado:
		carga += 0.5
		_iniciar_sonido_cargando()
		if carga >= 100.0:
			carga = 100.0
			_detener_sonido_cargando()
			if temporal:
				if not activo:
					activo = true
					_detener_sonido_cargando()
					sonido_carga_completa.play()
					Global.activar_mecanismo.emit(self)
			elif not cargado:
				cargado = true
				activo = true
				_detener_sonido_cargando()
				sonido_carga_completa.play()
				Global.activar_mecanismo.emit(self)
	else:
		if temporal:
			carga -= 3.0
			if activo and carga < 100.0:
				activo = false
				Global.desactivar_mecanismo.emit(self)
		_detener_sonido_cargando()

func _iniciar_sonido_cargando():
	if not sonido_cargando_activo:
		sonido_cargando.play()
		sonido_cargando_activo = true

func _detener_sonido_cargando():
	if sonido_cargando_activo:
		sonido_cargando.stop()
		sonido_cargando_activo = false
