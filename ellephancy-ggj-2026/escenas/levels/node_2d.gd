extends Node2D

var mover_camara : bool = false
@export var factor_tiempo : float = 0.8 #para que el movimiento sea 20% mas rapido q antes, podemos ajustarlo igual
var minimo_tiempo : float = 0.5
@export var player : Player
@export var factor_aumento : float = 24 #se usa en on_player_detecto_caida, para que se multiplique el tiempo en el aire x esta variable

func _ready() -> void:
	Global.puerta_abierta.connect(mover_camara_a_puerta)
	Global.player_detecto_caida.connect(on_player_detecto_caida)


func _physics_process(_delta: float) -> void:
	if mover_camara:
		pass
	else:
		if Input.is_action_pressed("click der"):
			position = get_local_mouse_position() * 0.5
		if Input.is_action_just_released("click der"):
			position = Vector2.ZERO

func mover_camara_a_puerta(global_position, tiempo_de_apertura):
	mover_camara = true
	var tiempo_camara = max(tiempo_de_apertura * factor_tiempo, minimo_tiempo) #agregado pre showcase
	var tween_camara = create_tween()
	tween_camara.tween_property(self, "global_position", global_position, 0.3).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(tiempo_camara).timeout
	position = Vector2.ZERO #reinicio
	mover_camara = false

func on_player_detecto_caida(tiempo_en_el_aire : float):
	var maximo_movimiento_camara = min(tiempo_en_el_aire * factor_aumento, 50)
	#print("el maximo movimiento de camara vale: ", maximo_movimiento_camara)
	mover_camara = false
	#print("MOVER CAMARAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	var tween_camara2 = create_tween()
	tween_camara2.tween_property(self, "position", Vector2(position.x, position.y + maximo_movimiento_camara), 0.3)
	tween_camara2.tween_property(self, "position", Vector2.ZERO, 0.3)
	mover_camara = false
