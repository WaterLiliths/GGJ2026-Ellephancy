class_name PlayerStats
extends Node #probar pasar a resource
##ACA PONEMOS TODO LO QUE SEA EXPORT VAR Y/O ESTADISTICAS DE PLAYER


@export var limite_altura_morir : float = 2000
@export var aceleracion : float = 1800.0
@export var desaceleracion : float = 2200.0
@export var velocidad_max : float = 250.0
@export var gravedad_subiendo : float = 1.0
@export var gravedad_bajando : float = 1.4
@export var velocidad : float = 250.0
@export var velocidad_salto: float = -620
@export var velocidad_salto_con_mascara = -800
@export var desaceleración_al_saltar : float = 0.5 #arreglar igual 0.5 safa
@export var desaceleracion_horizontal : float = 0.07 #ajustable a gusto
@export var velocidad_al_agarrar : float = 250
@export var aceleracion_al_agarrar : float = 0.2
@export var velocidad_correr : float = 40
@export var fuerza_empuje : float = 2000 #no anda
@export var velocidad_arrastrando : float = 100.0
