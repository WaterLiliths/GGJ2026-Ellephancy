extends TileMapLayer


@export var presente : bool
@export var background : bool
@export var es_exterior : bool = false

var _player: CharacterBody2D
var _was_inside := false
var _tween: Tween
var _inside := false

func _ready() -> void:
	Global.mascara_tiempo_activa.connect(on_mascara_tiempo_activa)
	Global.mascara_tiempo_desactivar.connect(on_mascara_tiempo_desactivada)
	if not presente:
		esconder_mundo()
	if es_exterior:
		_player = get_tree().get_first_node_in_group("player")
		collision_enabled = false

func _physics_process(delta: float) -> void:
	if not es_exterior or not _player:
		return
	var tile_pos := local_to_map(to_local(_player.global_position))
	var inside := get_cell_source_id(tile_pos) != -1
	if inside != _was_inside:
		_was_inside = inside
		_inside = inside
		notify_runtime_tile_data_update()
		if _tween:
			_tween.kill()
		_tween = create_tween()
		_tween.tween_property(self, "modulate:a", 0.0 if inside else 1.0, 0.3)


func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return true

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	if _inside:
		tile_data.set_occluder(0, null)



func on_mascara_tiempo_activa():
	#print("SE USO MASCARAAAAAAAAAAAAAAAAA")
	if presente:
		esconder_mundo()
	else:
		mostrar_mundo()


func on_mascara_tiempo_desactivada():
	if presente:
		mostrar_mundo() #hago lo contrario nada mas
		#codigo unga unga pero anda 
	else:
		esconder_mundo()

func esconder_mundo():
	collision_enabled = false
	hide()


func mostrar_mundo():
	if not background:
		collision_enabled = true
	show()
