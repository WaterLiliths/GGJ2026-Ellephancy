extends Control

#el nodo que se llama opciones lo podemos sacar
var pausa_activa : bool = false
@onready var canvas_layer_main: CanvasLayer = %CanvasLayerMain
@onready var canvas_layer_salir: CanvasLayer = %CanvasLayerSalir
var escena_menu_inicio : PackedScene = preload("res://escenas/main_menu.tscn")

func _ready() -> void:
	canvas_layer_main.hide()
	canvas_layer_salir.hide()
	process_mode = Node.PROCESS_MODE_ALWAYS #para q podamos acceder al hud aunque este en pausa

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pausa"):
		pausar()


func pausar():
	if not pausa_activa:
		canvas_layer_main.show()
		pausa_activa = true
		get_tree().paused = true
	else:
		canvas_layer_main.hide()
		canvas_layer_salir.hide()
		pausa_activa = false
		get_tree().paused = false


func _on_btn_reanudar_pressed() -> void:
	pausar()
	print("reanudar juegoooooooo")


func _on_btn_opciones_pressed() -> void:
	#aca lo vemos mañana si quieren
	#pq si el volumen es modular lo podemos pegar aca sin problema
	pass # Replace with function body.


func _on_btn_salir_pressed() -> void:
	canvas_layer_main.hide()
	canvas_layer_salir.show()


func _on_btn_si_pressed() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(escena_menu_inicio)


func _on_btn_si_2_pressed() -> void:
	canvas_layer_main.show()
	canvas_layer_salir.hide()
