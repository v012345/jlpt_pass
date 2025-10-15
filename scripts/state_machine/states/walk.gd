extends StateBase

@export var obj: CharacterBody2D
@export var ani: AnimationPlayer
@export var sm: StateMachine

var walk_codes = [KEY_A, KEY_W, KEY_S, KEY_D]
var current_ani: String
var current_face: String
func enter(_event=null):
	print("Walk")
	current_ani = ""
	current_face = ""

func _unhandled_key_input(event: InputEvent) -> void:
	if not walk_codes.has(event.keycode):
		sm.change_to("Idle", event)
	elif not GlobalFunction.is_pressing_move_key():
		sm.change_to("Idle")
	get_viewport().set_input_as_handled()

func _unhandled_input(_event: InputEvent) -> void:
	get_viewport().set_input_as_handled()

func change_ani(new_ani):
	if new_ani != current_ani:
		ani.play(new_ani)
		ani.seek(0, true)
		current_ani = new_ani

func stop()->void:
	if current_face != current_ani:
		current_face = current_ani.replace("walk", "idle")
		current_ani = current_face
		ani.play(current_face)
		ani.seek(0, true)

func _physics_process(_delta: float) -> void:
	# 获取移动方向（Godot 内置方法）
	var dir = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	if dir == Vector2.ZERO: return stop()
	# 计算它们的夹角余弦
	var dot_value = Vector2.DOWN.dot(dir)
	if dot_value > 0.95: # 余弦值接近 1 → 角度小于约 18°
		change_ani("walk_down")
	elif dot_value < -0.95:
		change_ani("walk_up")
	elif dir.x > 0:
		change_ani("walk_right")
	else:
		change_ani("walk_left")
	obj.velocity = dir * 100
	obj.move_and_slide()
	# print(dir)
