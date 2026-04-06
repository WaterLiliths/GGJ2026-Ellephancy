class_name HazDeLuz
extends Node2D

const LONGITUD_MAXIMA : int = 2000
var emisor
var rebotes : int = 15
var max_target_position
var rot : float = 0.0
var haces := []
@export var id_haz : int = 0
@onready var line_2d: Line2D = $Line2D
@onready var haz: RayCast2D = $Haz
@onready var particulas: CPUParticles2D = $Particulas
@onready var point_light_2d: PointLight2D = $PointLight2D

func _ready() -> void:
	emisor = get_parent()
	max_target_position = Vector2(LONGITUD_MAXIMA, 0)
	haz.target_position = max_target_position
	line_2d.top_level = true
	haces.append(haz)
	
	for i in range(rebotes):
		var rc := haz.duplicate()
		rc.enabled = false
		add_child(rc)
		haces.append(rc)

func _physics_process(delta: float) -> void:
	line_2d.clear_points()
	
	for i in range(1, haces.size()):
		haces[i].enabled = false
		haces[i].clear_exceptions()
	haces[0].clear_exceptions()
	
	var current_origin : Vector2 = global_position
	var current_dir : Vector2 = Vector2(LONGITUD_MAXIMA, 0).rotated(global_rotation)
	
	line_2d.add_point(current_origin)
	
	haces[0].global_position = current_origin
	haces[0].global_rotation = 0.0
	haces[0].target_position = current_dir
	haces[0].enabled = true
	
	for i in range(haces.size()):
		var cast : RayCast2D = haces[i]
		
		if not cast.enabled:
			break
		
		if not cast.is_colliding():
			line_2d.add_point(current_origin + current_dir)
			particulas.global_position = current_origin + current_dir
			point_light_2d.global_position = current_origin + current_dir
			for j in range(i + 1, haces.size()):
				haces[j].enabled = false
			break
		
		var hit_point : Vector2 = cast.get_collision_point()
		var normal : Vector2 = cast.get_collision_normal()
		var collider = cast.get_collider()
		
		line_2d.add_point(hit_point)
		
		if collider is Espejo:
			current_dir = current_dir.bounce(normal).normalized() * LONGITUD_MAXIMA
		elif collider is Lente:
			current_dir = current_dir.reflect(normal).normalized() * LONGITUD_MAXIMA
		elif collider is ObjetivoOptico:
			collider.recibir_haz(id_haz)
			particulas.global_position = hit_point
			point_light_2d.global_position = hit_point
			break
		else:
			particulas.global_position = hit_point
			particulas.direction = -current_dir
			point_light_2d.global_position = hit_point
			break
		
		if i + 1 < haces.size():
			var next_origin := hit_point + current_dir.normalized()
			haces[i + 1].global_position = next_origin
			haces[i + 1].global_rotation = 0.0
			haces[i + 1].target_position = current_dir
			haces[i + 1].add_exception(collider)
			haces[i + 1].enabled = true
			haces[i + 1].force_raycast_update()
			current_origin = next_origin
