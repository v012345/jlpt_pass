extends Node
class_name SceneInitializer

@export var root_view : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.open_view(root_view,false)
