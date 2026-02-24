extends Area2D
#oso
var player_cerca : bool = false
@export var area_dialogo_prueba: Area2D
@onready var sprite_2d_oso: Sprite2D = %Sprite2DOso


func _ready() -> void:
	area_dialogo_prueba.monitoring = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interactuar") and player_cerca:
		tomar_mascara()


#-------------SEÑALES------------
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_cerca = true


#-------------FUNCIONES--------------
func tomar_mascara():
	Global.tiene_mascara_fuerza = true
	Global.agarre_mascara.emit(2)
	sprite_2d_oso.hide()
	area_dialogo_prueba.forzar_lectura()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_cerca = false

func termino_dialogo():
	print("termino el dialogo del oso")
	Global.dialogo_desactivado_to_player.emit()
	queue_free()


func _on_area_dialogo_prueba_termino_lectura_forzada() -> void:
	termino_dialogo()
