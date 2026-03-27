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
	# _open_view_wait_book(Const.Views.multiple_choice)
	var select_book = SceneManager.open_view(Const.Views.select_book, false)
	select_book.set_info(book_ids, func(book):
		select_book.queue_free()
		var temp = range(1, 51)
		temp.shuffle()
		SceneManager.open_view(Const.Views.multiple_choice).init(temp)
	)

func _on_button_goto_stardew_valley_pressed() -> void:
	#SceneManager.change_scene(Const.Scenes.stardew_valley)
	var output = []
	var exit_code = OS.execute("py", ["C:\\Users\\A\\Desktop\\work\\NightOwlToolsV2\\tool_scripts\\Python\\test.py", "--xlsx","C:\\Users\\A\\Desktop\\work\\leaper\\leaper_design\\design\\tables\\HeroList.xlsx", "--json",ProjectSettings.globalize_path("user://")+"HeroList.json"], output)
	print("exit_code:", exit_code)
	print("output:", output)
	var path = "user://HeroList.json"
	# 1. 打开文件
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("文件打开失败:", path)
		return


	# 2. 读取文本
	var text = file.get_as_text()

	# 3. 解析 JSON
	var data = JSON.parse_string(text)

	if data == null:
		print("JSON 解析失败")
		return

	print(data)


func _on_button_exit_pressed() -> void:
	get_tree().quit()


func _on_button_goto_kitchen_pressed() -> void:
	SceneManager.change_scene(Const.Scenes.kitchen)
