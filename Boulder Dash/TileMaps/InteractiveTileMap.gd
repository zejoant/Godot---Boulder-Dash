extends TileMap

export(Dictionary) var TILE_SCENES := {
	0: preload("res://Misc Objects/Boulder.tscn"),
	1: preload("res://Misc Objects/Diamond.tscn"),
	2: preload("res://Enemies/Butterfly.tscn"),
	3: preload("res://Enemies/Square.tscn"),
	4: preload("res://Enemies/Amoeba.tscn"),
	5: preload("res://Misc Objects/Exit.tscn"),
}
#var rng = RandomNumberGenerator.new()

onready var half_cell_size := cell_size * 0.5
var palette

func _ready():
	yield(get_tree(), "idle_frame")
	palette = get_parent().palettes["interactive"]
	_replace_tiles_with_scenes()
	visible = false
	queue_free()

func _replace_tiles_with_scenes(scene_dictionary: Dictionary = TILE_SCENES):
	for tile_pos in get_used_cells():
		var tile_id = get_cell(tile_pos.x, tile_pos.y)
		
		if scene_dictionary.has(tile_id):
			var object_scene = scene_dictionary[tile_id]
			_replace_tile_with_object(tile_id, tile_pos, object_scene)

func _replace_tile_with_object(tile_id: int, tile_pos: Vector2, object_scene: PackedScene, _parent: Node = get_tree().current_scene):

	#Spawns the object
	if object_scene:
		var obj = object_scene.instance()
		var ob_pos = map_to_world(tile_pos) + half_cell_size
		
		owner.add_child(obj)
		if obj.get_node("Sprite").material != null:
			obj.get_node("Sprite").material.set_shader_param("palette_choice", palette[tile_id])
		obj.visible = true
		obj.global_position = ob_pos
		

