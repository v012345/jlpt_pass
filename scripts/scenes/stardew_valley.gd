extends SceneBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	#GlobalFunction.popup(self, "res://popups/card_info.tscn", false)
	print(EntityManager.player.focus)
	EntityManager.player.focus= true
	print(EntityManager.player.focus)
	EntityManager.player.set_state("Idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
