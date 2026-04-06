extends Area2D
#salmon, me re confundia sino
var player_cerca : bool = false
@export var area_dialogo_prueba: Area2D
@onready var sprite_2d_salmon: Sprite2D = %Sprite2DSalmon


func _ready() -> void:
	#area_dialogo_prueba.dialogue_ended.connect(termino_dialogo)
	#await get_tree().create_timer(1).timeout
	#area_dialogo_prueba.monitoring = false
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interactuar") and player_cerca:
		tomar_mascara()

#-------------FUNCIONES--------------
func tomar_mascara():
	Global.tiene_mascara_traducciones = true
	Global.agarre_mascara.emit(3)
	sprite_2d_salmon.hide()
	area_dialogo_prueba.forzar_lectura()
	Global.guardar_datos()


#---------------SEÑALES--------------
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_cerca = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_cerca = false


func termino_dialogo():
	print("termino el dialogo del SALMON")
	Global.dialogo_desactivado_to_player.emit()
	queue_free()


func _on_area_dialogo_prueba_termino_lectura_forzada() -> void:
	termino_dialogo()
