extends Node2D #mascara de los tiempos la 1

@export var id : int = 1
@export var activa : bool = false
@onready var color_rect_shader: ColorRect = %ColorRectShader
var material_shader :ShaderMaterial
var shader_water_color_final = Color(0.0, 0.3214, 0.7775, 1.0)
var shader_water_color_inicial = Color(1.0, 1.0, 1.0, 0.003)
var shader_color_core_inicial = 0.9
var shader_color_core_final = 0.35
var shader_backGroundDirX_final = 0.75
var shader_backGroundDirX_inicial = 0.01
var shader_backGroundDirY_inicial = 0.01
var shader_backGroundDirY_final = 0.75

func _ready() -> void:
	material_shader = color_rect_shader.material.duplicate() #primero lo duplico
	color_rect_shader.material = material_shader #le asigno el duplicado
	shader_color_core_inicial = material_shader.get_shader_parameter("colorCorection")
	shader_water_color_inicial = material_shader.get_shader_parameter("waterColor")
	print("el valor del shader es ", shader_water_color_inicial)

func usar():
	if activa:
		return
	activa = true
	Global.mascara_activa = id
	animacion_shader()
	await get_tree().create_timer(0.2).timeout
	Global.mascara_tiempo_activa.emit()
	print("se uso la mascara de tiempos")




func desactivar():
	if not activa: #si ya estaba desactivada
		return
	activa = false
	animacion_shader()
	await get_tree().create_timer(0.2).timeout
	Global.mascara_tiempo_desactivar.emit()




func animacion_shader(activar: bool = true, duracion: float = 0.6):
	shader_efecto_full(0.2)
	await get_tree().create_timer(0.2).timeout
	shader_efecto_inicial(0.2)

func shader_efecto_full(duracion):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(material_shader,"shader_parameter/waterColor",shader_water_color_final,duracion)
	tween.tween_property(material_shader,"shader_parameter/colorCorection",shader_color_core_final,duracion)
	tween.tween_property(material_shader,"shader_parameter/backGroundDirX",shader_backGroundDirX_final,duracion)
	tween.tween_property(material_shader,"shader_parameter/backGroundDirY",shader_backGroundDirY_final,duracion)


func shader_efecto_inicial(duracion):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(material_shader,"shader_parameter/waterColor",shader_water_color_inicial,duracion)
	tween.tween_property(material_shader,"shader_parameter/colorCorection",shader_color_core_inicial,duracion)
	tween.tween_property(material_shader,"shader_parameter/backGroundDirX",shader_backGroundDirX_inicial,duracion)
	tween.tween_property(material_shader,"shader_parameter/backGroundDirY",shader_backGroundDirY_inicial,duracion)
