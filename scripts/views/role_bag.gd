extends ViewBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func _on_button_leave_pressed() -> void:
	SceneManager.change_scene(Const.Scenes.balatro)
