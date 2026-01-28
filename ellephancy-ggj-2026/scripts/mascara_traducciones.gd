extends Mascara 

@export var referencia_player : Player
#aguanten los wachiturros (?
func _ready() -> void:
	Global.usar_mascara.connect(on_recibir_signal_usar)

func usar():
	if estaba_activa():
		return
	Global.mascara_traducciones_activa.emit()
	activar()
	print("se uso la mascara de traducciones")


func on_recibir_signal_usar(id_referencia : int):
	if id_referencia == id:
		usar()
	else:
		desactivar()
		referencia_player.desactivar_mascara_fuerza() #solo esta tiene llamada directa a player
		#el resto si tiene full señales
