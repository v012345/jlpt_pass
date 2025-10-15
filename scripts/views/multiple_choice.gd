extends ViewBase
@export var show_log: bool = false
@export var question_total: int = 20 ## 一副牌的数量
@export var choices_per_question: int = 4 ## 选项数
@export var dealer: Dealer
@export var discard_pile: Control
@export var deck: Deck
@export var display_hand: BaseHand
@export var choice_hand: BaseHand
var _card_ids
var _right_ids = []
var _wrong_ids = []
var _question_total := 0
func init(card_ids: Array, exam_all_cards := false) -> void:
	self._card_ids = card_ids
	if exam_all_cards:
		_question_total = card_ids.size()
	else:
		_question_total = question_total
	assert(choices_per_question >= 2, "选项数太少")
	# assert(card_ids.size() >= question_total * choices_per_question, "题目太多")
	var question_ids: Array = self._card_ids.slice(0, _question_total)
	var book_id = Model.JapaneseModel.get_word_belong_book(question_ids[0])
	var all_words = Model.JapaneseModel.get_words_of_book(book_id)
	var remained_words = all_words.filter(func(x): return not question_ids.has(x))
	var choice_ids: Array = remained_words.slice(0, (choices_per_question - 1) * _question_total)
	deck.init(choice_ids, Const.Entities.match_card, "chinese")
	var cards = deck.get_all_cards() as Array
	var j = 0
	for i in range(cards.size(), 0, 1 - choices_per_question):
		var answer = EntityManager.create_entity(Const.Entities.match_card) as BaseCard
		answer.init(question_ids[j], "chinese")
		var question = EntityManager.create_entity(Const.Entities.listening_card) as BaseCard
		question.init(question_ids[j], "kana")
		cards.insert(i, question)
		cards.insert(i, answer)
		j += 1
	deck.refresh()
	display_hand.init(discard_pile, 1)
	choice_hand.init(discard_pile, choices_per_question)
	GlobalFunction.block_input(true)
	await _deal_cards()
	display_hand.play_question()
	choice_hand.need_refill_hand.connect(self._on_need_refill_hand)
	GlobalFunction.block_input(false)

func _on_need_refill_hand(_hand):
	await _deal_cards()
	display_hand.play_question()

func _record(key: String, ids: Array):
	var data = GlobalStorage.get_value(key, {}) as Dictionary
	for id in ids:
		var _id = str(id)
		if data.has(_id):
			data[_id] = data[_id] + 1
		else:
			data[_id] = 1
	GlobalStorage.save(key, data)

func _record_exam_time(ids: Array):
	var data = GlobalStorage.get_value("exam_time", {}) as Dictionary
	for id in ids:
		var _id = str(id)
		data[_id] = Time.get_unix_time_from_system()
	GlobalStorage.save("exam_time", data)

func _deal_cards():
	if max(display_hand.holding_cards_num, deck.get_card_num()) <= 0:
		PopupManager.popup(self, Const.Views.exam_result, true, func(exam_result):
			exam_result.wrong.text = str(_wrong_ids.size())
			exam_result.right.text = str(_right_ids.size())
			if _wrong_ids.size() > 0:
				exam_result.comfirm_btn.pressed.connect(func():
					self.queue_free()
					SceneManager.open_view(Const.Views.learn_words).init(_wrong_ids, true)
				)
			else:
				exam_result.comfirm_btn.text = "你太厉害了!"
				exam_result.comfirm_btn.pressed.connect(func():
					self.queue_free()
				)
			)
		return
	# 拿缺少的手牌数或剩下的所有牌
	var cards = deck.draw_cards(1)
	await dealer.deal(cards, display_hand, deck)
	cards = deck.draw_cards(choices_per_question)
	cards.shuffle()
	await dealer.deal(cards, choice_hand, deck)


func _on_button_confirm_pressed() -> void:
	var c1 = display_hand.get_all_cards()
	var c2 = choice_hand.get_selected_cards()
	if c1.size() > 0 and c2.size() > 0:
		if c1[0].id == c2[0].id:
			_record("right", [c1[0].id])
			_right_ids.append(c1[0].id)
		else:
			_record("wrong", [c1[0].id])
			_wrong_ids.append(c1[0].id)
		_record_exam_time([c1[0].id])
		await display_hand.discard_cards(c1)
		await choice_hand.discard_cards(choice_hand.get_all_cards())
