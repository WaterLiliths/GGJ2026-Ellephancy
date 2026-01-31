extends TileMapLayer


@export var presente : bool


func _ready() -> void:
	Global.mascara_tiempo_activa.connect(on_mascara_tiempo_activa)
	Global.mascara_tiempo_desactivar.connect(on_mascara_tiempo_desactivada)
	if not presente:
		esconder_mundo()


func on_mascara_tiempo_activa():
	print("SE USO MASCARAAAAAAAAAAAAAAAAA")
	if presente:
		esconder_mundo()
	else:
		mostrar_mundo()


func on_mascara_tiempo_desactivada():
	if presente:
		mostrar_mundo() #hago lo contrario nada mas
		#codigo unga unga pero anda 
	else:
		esconder_mundo()

func esconder_mundo():
	collision_enabled = false
	hide()


func mostrar_mundo():
	collision_enabled = true
	show()
