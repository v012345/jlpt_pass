extends DataModelBase
class_name JapaneseModel

func _ready() -> void:
	pass

func get_words_of_book(book_id: int, need_shuffle: bool = true):
	var card_ids = []
	for j in GlobalDb.words.japanese:
		if GlobalDb.words.japanese[j].book_id == book_id:
			card_ids.append(j)
	if need_shuffle: card_ids.shuffle() # 打乱顺序
	return card_ids

func get_word_belong_book(word_id):
	return GlobalDb.words.japanese[word_id].book_id
