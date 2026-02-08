extends Node2D

var tween = create_tween()

func _ready() -> void:
	#$Player/Camera2D/Control/IconoMascaraOso.hide()
	#$Player/Camera2D/Control/IconoMascaraSalmon.hide()
	#$Player/Camera2D/Control/IconoMascaraCiervo.hide()
#	$Opciones.visible = false
	$FmodEventEmitter2D2.volume = 0.0
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	$FmodEventEmitter2D2.play()
	#$AnimationPlayer.play("fade_in") #la animacion ahora se inicializa directamente en el animation player
	tween.tween_property($FmodEventEmitter2D2, "volume", Global.volumen_musica, 4)
	Global.mascara_tiempo_activa.connect(cambiar_ambiente_pasado)
	Global.mascara_tiempo_desactivar.connect(cambiar_sonido_presente)
	
#Rezá Malena rezá

func _process(delta: float) -> void:
	$FmodEventEmitter2D2.volume = Global.volumen_musica
	$FmodEventEmitter2D.volume = Global.volumen_ambiente
	
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

func cambiar_ambiente_pasado():
	$FmodEventEmitter2D.set_parameter("Tiempo", "pasado")
	
func cambiar_sonido_presente():
	$FmodEventEmitter2D.set_parameter("Tiempo", "presente")
