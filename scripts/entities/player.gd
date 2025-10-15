extends CharacterBody2D
class_name PlayerEntity

var focus: bool = true:
	set(b):
		focus = b
		$Camera2D.enabled = b
	get: return focus

var wrong_word_ids = []

func set_state(state):
	$StateMachine.change_to(state)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.y = 100
	# SceneManager.open_view("res://popups/stardew_valley/bottom_bag.tscn")
