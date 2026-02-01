extends Area2D

var player_adentro : bool = false
@export var sprite_asociado : Node
@export var id_palanca : int = 3
signal activar_cambiar_runa(id_palanca_int : int)
@onready var controlador_runas: Node2D = %PuzzleSalmon1
@onready var animation_player_3: AnimationPlayer = %AnimationPlayer3
var usada: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_adentro = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_adentro = false


func _physics_process(delta: float) -> void:
	if player_adentro and Input.is_action_just_pressed("interactuar"):
		activar_cambiar_runa.emit(id_palanca)
		if usada:
			animation_player_3.play("activar")
		else:
			animation_player_3.play("desactivar")
		usada = not usada
