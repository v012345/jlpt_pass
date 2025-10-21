extends SceneBase
@export var tilemap_layer: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	#GlobalFunction.popup(self, "res://popups/card_info.tscn", false)
	print(EntityManager.player.focus)
	EntityManager.player.focus= true
	print(EntityManager.player.focus)
	EntityManager.player.set_state("Idle")
	var used_rect = tilemap_layer.get_used_rect()
	var cell_size = tilemap_layer.tile_set.tile_size
	var top_left = tilemap_layer.map_to_local(used_rect.position)
	var bottom_right = tilemap_layer.map_to_local(used_rect.position + used_rect.size)
	print(used_rect)
	print(cell_size)
	print(top_left)
	print(bottom_right)
	EntityManager.player.camera.set_limit(SIDE_LEFT , int(top_left.x - cell_size.x / 2))
	EntityManager.player.camera.set_limit(SIDE_TOP, int(top_left.y - cell_size.y / 2))
	EntityManager.player.camera.set_limit(SIDE_RIGHT, int(bottom_right.x + cell_size.x / 2))
	EntityManager.player.camera.set_limit(SIDE_BOTTOM, int(bottom_right.y + cell_size.y / 2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
