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
	haces.append(haz)
	emisor = get_parent()
	#haz.rotation_degrees = emisor
	for i in range(rebotes):
		var raycast = haz.duplicate()
		raycast.enabled = false
		#raycast.add_exception(emisor)
		add_child(raycast)
		haces.append(raycast)
		
	max_target_position = Vector2(LONGITUD_MAXIMA, 0)
	haz.target_position = max_target_position
	line_2d.top_level = true


func _physics_process(delta: float) -> void:
	
	
	line_2d.clear_points()
	line_2d.add_point(global_position)

	max_target_position = Vector2(LONGITUD_MAXIMA, 0)
	
	var idx = -1
	for raycast in haces:
		idx += 1
		var raycastcollision = raycast.get_collision_point()
		raycast.target_position = max_target_position
		
		if raycast.is_colliding():
			line_2d.add_point(raycastcollision)
			var collider = raycast.get_collider()
			if collider is Espejo:
				max_target_position = max_target_position.bounce(raycast.get_collision_normal())
			elif collider is Lente:
				max_target_position = max_target_position.reflect(raycast.get_collision_normal() * -1)
			elif collider is ObjetivoOptico:
				collider.recibir_haz(id_haz)
				max_target_position = position
			if idx < haces.size() - 1:
				haces[idx+1].enabled = true
				haces[idx+1].global_position = raycastcollision + (max_target_position.normalized())
			if idx == haces.size() - 1:
				particulas.global_position = raycastcollision
				point_light_2d.global_position = raycastcollision
	
		else:
			line_2d.add_point(global_position + max_target_position.rotated(global_rotation))
			if idx == 0:
				raycast.target_position = max_target_position
				particulas.global_position = global_position + max_target_position
				point_light_2d.global_position = global_position + max_target_position
			else:
				particulas.global_position = raycast.global_position + max_target_position
				point_light_2d.global_position = raycast.global_position + max_target_position
			
