extends ViewBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_role_btn_pressed() -> void:
	pass # Replace with function body.


func _on_heros_btn_pressed() -> void:
	SceneManager.open_view(Const.Views.hero_list_xlsx)
	pass # Replace with function body.
