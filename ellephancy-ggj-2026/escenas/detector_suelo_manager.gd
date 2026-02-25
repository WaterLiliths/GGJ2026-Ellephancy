class_name DetectorSueloManager
extends Node


@export var player : Player
@export var sound_manager : SoundManager
@export var raycast_suelo : RayCast2D
var posicion_pies 
var tipo_de_suelo

func _ready() -> void:
	posicion_pies = player.global_position + Vector2(0, 1)


func obtener_tile_map():
	var tilemap : TileMapLayer
	if raycast_suelo.is_colliding():
		tilemap = raycast_suelo.get_collider()
		return tilemap



func detectar_tipo_de_suelo():
	posicion_pies = raycast_suelo.global_position
	if raycast_suelo.is_colliding():
		if raycast_suelo.get_collider() is TileMapLayer:
			var tilemap = obtener_tile_map()
			var coords: Vector2i = tilemap.local_to_map(tilemap.to_local(posicion_pies))
			var tile_data : TileData = tilemap.get_cell_tile_data(coords)
			
			if tilemap == null:
				return

			if tile_data:
				tipo_de_suelo = tile_data.get_custom_data("suelo")
			
				#print("tipo de suelo es: " , tipo_de_suelo)
			#tilemap = null


func _physics_process(delta: float) -> void:
	detectar_tipo_de_suelo()
	
	if tipo_de_suelo:
		%FmodEventEmitter2D.set_parameter("Superficie", tipo_de_suelo)
		%FmodEventEmitter2D4.set_parameter("Superficie", tipo_de_suelo)
		%FmodEventEmitter2D2.set_parameter("Superficie", tipo_de_suelo)
