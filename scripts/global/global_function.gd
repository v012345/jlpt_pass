extends Node

var app: App
var _is_input_blocked: bool

func _ready() -> void:
	print("Function Ready!")

func is_pressing_move_key()->bool:
	return Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right") or Input.is_action_pressed("walk_up") or Input.is_action_pressed("walk_down")


func stop_play_segments():
	app.play_segments([ {"path": "", "sound_start": 0, "sound_end": 0, }])

func play_segments(sounds):
	app.play_segments(sounds)

func get_words_of_book(book_id: int, need_shuffle: bool = true):
	var card_ids = []
	for j in GlobalDb.words.japanese:
		if GlobalDb.words.japanese[j].book_id == book_id:
			card_ids.append(j)
	if need_shuffle: card_ids.shuffle() # 打乱顺序
	return card_ids

func block_input(b: bool):
	app.block_input(b)
	_is_input_blocked = b

func is_input_blocked() -> bool:
	return _is_input_blocked
	

func kill_tween(tween: Tween):
	if tween and tween.is_running():
		tween.kill()

func remove_all_children(node):
	for child in node.get_children():
		node.remove_child(child)

func print_log(isPrint: bool, content) -> void:
	if isPrint:
		print(content)
