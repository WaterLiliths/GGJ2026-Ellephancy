class_name Luciernagas
extends CharacterBody2D

@export var movement_speed: float = 200.0
@export var movement_target : Marker2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	navigation_agent_2d.path_desired_distance = 4.0
	navigation_agent_2d.target_desired_distance = 4.0
	
	actor_setup.call_deferred()
	
func _physics_process(delta: float) -> void:
	if navigation_agent_2d.is_navigation_finished():
		cpu_particles_2d.gravity = Vector2.UP
		return

	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent_2d.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	cpu_particles_2d.gravity = position.direction_to(next_path_position)

	move_and_slide()

func actor_setup():
	await get_tree().physics_frame
	
	set_movement_target_position(movement_target)
	
func set_movement_target_position(movement_target):
	navigation_agent_2d.target_position = movement_target.global_position
