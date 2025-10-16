extends DataModelBase
class_name JapaneseModel

var words_group_by_book = {}

func _ready() -> void:
	for book in GlobalDb.words.books.values():
		words_group_by_book[book.id] = []
	for word in GlobalDb.words.japanese.values():
		words_group_by_book[word.book_id].append(word)

func get_words_of_book(book_id: int, need_shuffle: bool = true):
	var card_ids = []
	for j in GlobalDb.words.japanese:
		if GlobalDb.words.japanese[j].book_id == book_id:
			card_ids.append(j)
	if need_shuffle: card_ids.shuffle() # 打乱顺序
	return card_ids

func get_word_belong_book(word_id):
	return GlobalDb.words.japanese[word_id].book_id

func get_for_match_use_words_of_book(book_id):
	var words = words_group_by_book[book_id]
	words.shuffle()
	var know = GlobalStorage.get_value("right", {}) as Dictionary
	var result = []
	for word in words:
		if know.has(str(word.id)):
			result.append(word.id)
	print(result)
	return result
