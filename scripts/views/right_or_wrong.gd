extends ViewBase
@export var checker:Sprite2D
@export var cross:Sprite2D
@export var main_node:Control

func _ready() -> void:
	super._ready()

func show_which(is_right:bool):
	checker.visible = is_right
	cross.visible = not is_right
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(main_node,"modulate:a",1,0.3).from(0)
	tween.parallel().tween_property(main_node,"scale",Vector2.ONE * 0.7 ,0.3).from(Vector2.ONE * 0.01)
	await tween.finished
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(main_node,"modulate:a",0,0.3)
	tween.parallel().tween_property(main_node,"scale",Vector2.ONE * 0.01,0.3)
	await tween.finished
	queue_free()
	
