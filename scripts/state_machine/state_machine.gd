extends Node
class_name StateMachine
var children = {}
var current_state: StateBase
@export var initial_state: StateBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in get_children():
		children[c.name] = c
		remove_child(c)
	current_state = initial_state
	add_child(initial_state)
	#initial_state.call_deferred("enter")
	initial_state.enter()

func change_to(state: String, event = null)->void:
	current_state.exit()
	call_deferred("remove_child", current_state)
	current_state = children[state]
	call_deferred("add_child", current_state)
	current_state.enter(event)
