extends ViewBase
var book_ids = [1, 2]
func _ready() -> void:
	super._ready()

func _open_view_wait_book(view):
	var select_book = SceneManager.open_view(Const.Views.select_book, false)
	select_book.set_info(book_ids, func(book):
		select_book.queue_free()
		SceneManager.open_view(view).init(GlobalFunction.get_words_of_book(book.id))
	)

func _on_button_learn_pressed() -> void:
	_open_view_wait_book(Const.Views.learn_words)
	

func _on_button_match_game_pressed() -> void:
	var select_book = SceneManager.open_view(Const.Views.select_book, false)
	select_book.set_info(book_ids, func(book):
		select_book.queue_free()
		SceneManager.open_view(Const.Views.match_game).init(Model.JapaneseModel.get_for_match_use_words_of_book(book.id))
	)
	

func _on_button_exam_pressed() -> void:
	_open_view_wait_book(Const.Views.multiple_choice)

func _on_button_goto_stardew_valley_pressed() -> void:
	SceneManager.change_scene(Const.Scenes.stardew_valley)


func _on_button_exit_pressed() -> void:
	get_tree().quit()
