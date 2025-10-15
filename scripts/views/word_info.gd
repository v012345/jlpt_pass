extends ViewBase


@export var show_card: Control
@export var kanji: Label
@export var chinese: Label
@export var example: VBoxContainer
@export var remember_num: Label
@export var forget_num: Label
@export var exam_time: Label


func set_info(card_id, card_template):
	# for child in show_card.get_children():
	# 	child.queue_free()
	var card: BaseCard = card_template.instantiate()
	var info = GlobalDb.words.japanese[card_id]
	card.init(card_id, "kana")
	card.flap_to_front(true)
	card.show_shadow = false
	show_card.add_child(card)
	card.position = card.get_size() / 2
	kanji.text = info.kanji
	chinese.text = info.chinese
	var know = GlobalStorage.get_value("right", {}) as Dictionary
	var id = str(card_id)
	if know.has(id): remember_num.text = str(int(know[id]))
	else: remember_num.text = "0"
	var unknow = GlobalStorage.get_value("wrong", {}) as Dictionary
	if unknow.has(id): forget_num.text = str(int(unknow[id]))
	else: forget_num.text = "0"
	var _exam_time = GlobalStorage.get_value("exam_time", {}) as Dictionary
	if _exam_time.has(id):
		var dt = Time.get_datetime_dict_from_unix_time(_exam_time[id])
		exam_time.text = "%04d-%02d-%02d %02d:%02d" % [dt.year, dt.month, dt.day, dt.hour, dt.minute]
	else: exam_time.text = "-"
	for child in example.get_children():
		child.queue_free()
	for example_id in info.example_id:
		var new_label = Label.new()
		var example_info = GlobalDb.words.example[example_id]
		new_label.text = example_info.japanese
		new_label.add_theme_font_size_override("font_size", 26)
		example.add_child(new_label)
		var new_label1 = Label.new()
		new_label1.text = example_info.chinese
		new_label1.add_theme_font_size_override("font_size", 24)
		example.add_child(new_label1)
