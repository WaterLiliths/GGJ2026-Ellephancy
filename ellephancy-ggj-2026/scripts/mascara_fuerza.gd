extends Mascara 

func _ready() -> void:
	Global.usar_mascara.connect(on_recibir_signal_usar)

func usar():
	if estaba_activa():
		return
	Global.mascara_fuerza_activa.emit()
	activar()
	print("se uso la mascara de fuerza")


func on_recibir_signal_usar(id_referencia : int):
	if id_referencia == id:
		usar()
	else:
		desactivar()

func get_estado_activa():
	return activa
