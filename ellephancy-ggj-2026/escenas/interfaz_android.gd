extends Control

#@onready var btn_izq: TouchScreenButton = %BtnIzq
#@onready var btn_der: TouchScreenButton = %BtnDer
#@onready var btn_saltar: TouchScreenButton = %BtnSaltar
#@onready var btn_interactuar: TouchScreenButton = %BtnInteractuar
#@onready var btn_abajo: TouchScreenButton = %BtnAbajo
#al final con las señales no hacen falta referencia a los botones
#forzar github
#TESTEAR - mas adelante cambiar los botones a unos más bonitos y propios


func _ready() -> void:
	Input.set_use_accumulated_input(false)
	esconder_botones_iniciales()


func esconder_botones_iniciales():
#	btn_interactuar.hide()
	#agregar mas 
	pass


func _on_btn_izq_button_down() -> void:
#	print("boton izquierdaaaaaaaaa")
	simular_apretar_boton("a") #aver si anda, simula el A D del teclado de pc


func _on_btn_der_button_down() -> void:
#	print("boton derechaaaaaaaaaa")
	simular_apretar_boton("d")


func _on_btn_izq_button_up() -> void:
#	print("solte el boton izquierdaaaa")
	simular_soltar_boton("a")


func _on_btn_der_button_up() -> void:
#	print("solte el boton derecho")
	simular_soltar_boton("d")

func simular_apretar_boton(nombre_del_input: String):
	var evento := InputEventAction.new()
	evento.action = nombre_del_input
	evento.pressed = true
	Input.parse_input_event(evento)

func simular_soltar_boton(nombre_del_input: String):
	var evento := InputEventAction.new()
	evento.action = nombre_del_input
	evento.pressed = false
	Input.parse_input_event(evento)


func _on_btn_saltar_button_down() -> void:
	simular_apretar_boton("w")


func _on_btn_saltar_button_up() -> void:
	simular_soltar_boton("w")


func _on_btn_interactuar_button_down() -> void:
	simular_apretar_boton("interactuar")
	simular_apretar_boton("tirar") #TODO VER SI CONVIENE DEJAR EL MISMO BOTON O HACER UNO NUEVO


func _on_btn_interactuar_button_up() -> void:
	simular_soltar_boton("interactuar")
	simular_soltar_boton("tirar") #TODO VER SI CONVIENE DEJAR EL MISMO BOTON O HACER UNO NUEVO


func _on_btn_abajo_pressed() -> void:
	simular_apretar_boton("s")


func _on_btn_abajo_released() -> void:
	simular_soltar_boton("s")


func _on_mascara_oso_pressed() -> void:
	simular_apretar_boton("1")


func _on_mascara_oso_released() -> void:
	simular_soltar_boton("1")


func _on_mascara_ciervo_pressed() -> void:
	simular_apretar_boton("2")


func _on_mascara_ciervo_released() -> void:
	simular_soltar_boton("2")


func _on_mascara_salmon_pressed() -> void:
	simular_apretar_boton("3")


func _on_mascara_salmon_released() -> void:
	simular_soltar_boton("3")
