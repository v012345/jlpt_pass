extends StateBase
@export var obj: CharacterBody2D
@export var ani: AnimationPlayer
@export var sm: StateMachine


func enter(_event = null):
	print("Vegetation")

func _unhandled_key_input(_event: InputEvent) -> void:
	get_viewport().set_input_as_handled()

func _unhandled_input(_event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
