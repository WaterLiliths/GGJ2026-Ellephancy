extends Node2D


@onready var animation_fade_out: AnimationPlayer = %AnimationPlayer
@export var manager_de_objetivos: ManagerDeObjetivos


func _ready() -> void:
	#$Player/Camera2D/Control/IconoMascaraOso.hide()
	#$Player/Camera2D/Control/IconoMascaraSalmon.hide()
	#$Player/Camera2D/Control/IconoMascaraCiervo.hide()
#	$Opciones.visible = false
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	#Global.cargar_datos() #mejor que el player sea quien cargue los datos
	Global.mascara_tiempo_activa.connect(cambiar_ambiente_pasado)
	Global.mascara_tiempo_desactivar.connect(cambiar_sonido_presente)
	
#Rezá Malena rezá


	
	#if $Player.obtuvo_mascara_oso:
		#$Player/Camera2D/Control/IconoMascaraOso.show()
		#$Player/Camera2D/Control/IconoMascaraOso/AnimationPlayer.play("fade_in")
		#$Player.obtuvo_mascara_oso = false
	#if $Player.obtuvo_mascara_salmon:
		#$Player/Camera2D/Control/IconoMascaraSalmon.show()
		#$Player/Camera2D/Control/IconoMascaraSalmon/AnimationPlayer.play("fade_in")
		#$Player.obtuvo_mascara_salmon = false
	#if $Player.obtuvo_mascara_ciervo:
		#$Player/Camera2D/Control/IconoMascaraCiervo.show()
		#$Player/Camera2D/Control/IconoMascaraCiervo/AnimationPlayer.play("fade_in")
		#$Player.obtuvo_mascara_ciervo = false
	#
	#if Global.mascara_activa == 0:
		#$Player/Camera2D/Control/IconoMascaraSalmon/AnimationPlayer.play("desactivar")
		#$Player/Camera2D/Control/IconoMascaraCiervo/AnimationPlayer.play("desactivar")

#func on_matar_jugador():
	#animation_fade_out.play("fade-revivir")




func cambiar_ambiente_pasado():
	return
	$FmodEventEmitter2D.set_parameter("Tiempo", "pasado")
	
func cambiar_sonido_presente():
	return
	$FmodEventEmitter2D.set_parameter("Tiempo", "presente")
