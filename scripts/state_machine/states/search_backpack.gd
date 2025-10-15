extends StateBase
@export var obj: CharacterBody2D
@export var ani: AnimationPlayer
@export var sm: StateMachine

var popup = null
var walk_codes = [KEY_A, KEY_W, KEY_S, KEY_D]

func enter(_event = null):
	print("SearchBackpack")
	popup = SceneManager.open_view(Const.Views.bag, false)

func _unhandled_key_input(event: InputEvent) -> void:
	if (event.keycode == KEY_E or event.keycode == KEY_ESCAPE) and event.is_pressed():
		popup.queue_free()
		return sm.change_to("Idle")
	get_viewport().set_input_as_handled()

func _unhandled_input(_event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
