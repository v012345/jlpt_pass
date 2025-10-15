extends StateBase
@export var obj: CharacterBody2D
@export var ani: AnimationPlayer
@export var sm: StateMachine

func _set_facing_direction():
	var dot_value = Vector2.DOWN.dot(obj.velocity.normalized())
	if dot_value > 0.95: # 余弦值接近 1 → 角度小于约 18°
		ani.play("idle_down")
	elif dot_value < -0.95:
		ani.play("idle_up")
	elif obj.velocity.x > 0:
		ani.play("idle_right")
	else:
		ani.play("idle_left")
	ani.seek(0, true)

func enter(event = null):
	print("Idle")
	# ani.play("idle_down")
	_set_facing_direction()
	if event:
		_deal_event(event)

func _deal_event(event)->void:
	if (event.keycode == KEY_E or event.keycode == KEY_ESCAPE) and event.is_pressed():
		return sm.change_to("SearchBackpack")
	if GlobalFunction.is_pressing_move_key():
		return sm.change_to("Walk")

func _unhandled_key_input(event: InputEvent) -> void:
	_deal_event(event)
	get_viewport().set_input_as_handled()

func _unhandled_input(_event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
