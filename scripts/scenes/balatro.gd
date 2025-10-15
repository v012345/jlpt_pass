extends SceneBase

var card_pos: Vector2

func _ready():
	super._ready()
	EntityManager.player.focus= false
	EntityManager.player.set_state("Vegetation")
	$Card.set_card_text("合\n格")
	$Card.show_icon = true
	$Card.scale_factor = $Card.scale.x
	$Card._is_front = true
	card_pos = $Card.position
	$Card.card_release.connect(self._on_card_release)
	var tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_destroy.parallel().tween_property($Card.material, "shader_parameter/dissolve_value", 1.0, 0.7).from(0.0)
	tween_destroy.parallel().tween_property($TileImage.material, "shader_parameter/dissolve_value", 1.0, 1.5).from(0.0)

func _on_card_release(card) -> void:
	create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).tween_property(card, "position", card_pos, 0.3)
