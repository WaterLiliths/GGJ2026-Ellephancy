class_name MascaraCiervo #esto esta RARO pero es temporal, en todo caso deberia hacer una clase mascara y que estas extiendan, pero todavia falta refactorizar para eso
extends Node2D #mascara de los tiempos la 1

@export var id : int = 1
@export var activa : bool = false
@export var texture_shader_expansivo: TextureRect
##cuanto tiempo queremos que dure el efecto del shader
@export var tiempo_shader : float = 1.3
var cambiando_mundos : bool = false

var material_shader_expansivo :ShaderMaterial

func _ready() -> void:
	material_shader_expansivo = texture_shader_expansivo.material.duplicate() #primero lo duplico
	texture_shader_expansivo.material = material_shader_expansivo #se le asigna el duplicado


func usar():
	if activa:
		return
	if cambiando_mundos: #esperamos a que termine el shader
		return
	activa = true
	Global.mascara_activa = id
	tomar_screenshot()
	Global.congelar_player.emit()
	animacion_activar_shader(tiempo_shader)
	await get_tree().create_timer(0.2).timeout
	Global.descongelar_player.emit()
	Global.mascara_tiempo_activa.emit()
	#print("se uso la mascara de tiempos")


func tomar_screenshot():
	var imagen = get_viewport().get_texture().get_image() #re loco, toma una screenshot del juego
	var textura = ImageTexture.create_from_image(imagen) #lo convierto en textura
	texture_shader_expansivo.texture = textura #y se lo asigno
	#esto pq el shader desvanece la textura que tiene colocada entonces da el efecto de que el mundo del pasado se esta yendo

func desactivar():
	if not activa: #si ya estaba desactivada
		return
	if cambiando_mundos:
		return
	activa = false
	tomar_screenshot()
	animacion_activar_shader(tiempo_shader)
	await get_tree().create_timer(0.2).timeout
	Global.mascara_tiempo_desactivar.emit()



func animacion_activar_shader(duracion : float = 0.2):
	#a este shader solo hay que modificarle el parametro progress para que funcione, en cero esta como apagado y en 1.0 prendido a full
	cambiando_mundos = true
	calcular_player_uv_position()
	var tween := create_tween()
	material_shader_expansivo.set_shader_parameter("progress", 0.0) #inicializo en 0.0
	texture_shader_expansivo.show()

	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	#tween.set_trans(Tween.TRANS_SINE) #opcion 2, da el efecto de que dura un poquito mas
	#tween.set_ease(Tween.EASE_IN)
	tween.tween_property(material_shader_expansivo,"shader_parameter/progress",1.0,duracion)
	await tween.finished
	cambiando_mundos = false
	texture_shader_expansivo.hide()

func calcular_player_uv_position(): #marge no voy a mentirte, no sabia como convertir la posicion del player en posiciones uv de pantalla asiq el chat me ayudo D:
	var screen_size := get_viewport().get_visible_rect().size
	var canvas_transform := get_viewport().get_canvas_transform()
	var player_screen_pos =canvas_transform * Global.get_player_position()
	var player_uv =player_screen_pos / screen_size
	material_shader_expansivo.set_shader_parameter("center",player_uv)
