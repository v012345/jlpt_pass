extends ViewBase
@export var show_log: bool = false
@export var card_num_of_a_deck: int = 24 ## 一副牌的数量
@export var max_cards_in_hand: int = 8 ## 最大手牌数
@export var card_template: PackedScene
@export var dealer: Dealer
@export var discard_pile: Control
@export var deck: Deck
@export var hand: BaseHand
@export var forget_area: Area2D
@export var remember_area: Area2D


var _card_ids
var _card_info: Control ## 如果非常快, 会出现生成 2 次, 然后释放 2 次的问题, 第二次释放会 bug
var _exam_word_id = []
var _card_num_of_a_deck: int
func init(card_ids: Array, learn_all_cards := false) -> void:
	_exam_word_id.clear()
	self._card_ids = card_ids
	if learn_all_cards: _card_num_of_a_deck = card_ids.size()
	else: _card_num_of_a_deck = card_num_of_a_deck

	var draw_card_ids: Array = self._card_ids.slice(0, _card_num_of_a_deck) # 取前50个
	deck.init(draw_card_ids, card_template, "kana")
	hand.init(discard_pile, max_cards_in_hand)
	GlobalFunction.block_input(true)
	await _deal_cards()
	GlobalFunction.block_input(false)

func _restart() -> void:
	_exam_word_id.clear()
	await hand.discard_cards(hand.get_all_cards())
	self._card_ids.shuffle()
	var draw_card_ids: Array = self._card_ids.slice(0, _card_num_of_a_deck) # 取前50个
	deck.init(draw_card_ids, card_template, "kana")
	GlobalFunction.block_input(true)
	await _deal_cards()
	GlobalFunction.block_input(false)

func _to_exam():
	self.queue_free()
	SceneManager.open_view(Const.Views.multiple_choice).init(_exam_word_id, true)
	

func _deal_cards():
	if max(hand.holding_cards_num, deck.get_card_num()) <= 0:
		var stage_clear = PopupManager.popup(self, Const.Views.stage_clear)
		stage_clear.play_again.connect(self._restart)
		stage_clear.to_exam.connect(self._to_exam)
		return
	# 拿缺少的手牌数或剩下的所有牌
	var cards = deck.draw_cards(min(hand.available_hand_slots(), deck.get_card_num()))
	# 发牌
	await dealer.deal(cards, hand, deck)

func _on_has_known_area_entered(area: Area2D) -> void:
	var card = area.get_parent()
	if not card.card_release.is_connected(self._on_card_release):
		card.card_release.connect(self._on_card_release)
	_card_info = SceneManager.call_deferred("popup_view", Const.Views.word_info, false, func(card_info):
		card_info.set_info(area.get_parent().id, Const.Entities.word_card)
		_card_info = card_info
	)

func _on_has_known_area_exited(area: Area2D) -> void:
	var card = area.get_parent()
	if card.card_release.is_connected(self._on_card_release):
		card.card_release.disconnect(self._on_card_release)
	if is_instance_valid(_card_info):
		_card_info.queue_free()

func _on_exchange_one_area_entered(area: Area2D) -> void:
	var card = area.get_parent()
	if not card.card_release.is_connected(self._on_card_release):
		card.card_release.connect(self._on_card_release)
	pass

func _on_exchange_one_area_exited(area: Area2D) -> void:
	var card = area.get_parent()
	if card.card_release.is_connected(self._on_card_release):
		card.card_release.disconnect(self._on_card_release)
	# hand.call_deferred("play_cards", [card])
	# deck.call_deferred("insert_cards", [card])
	# hand.play_cards([card])
	# deck.insert_cards([card])

func _on_card_release(card):
	card.set_collision(false)
	GlobalFunction.block_input(true)
	if forget_area.overlaps_area(card.get_area_2d()):
		_recored("unknow", [card.id])
		await hand.discard_cards([card])
		await _deal_cards()
	elif remember_area.overlaps_area(card.get_area_2d()):
		_recored("know", [card.id])
		_exam_word_id.append(card.id)
		# await hand.discard_cards([card])
		await hand.burn_cards([card])
		await _deal_cards()
	GlobalFunction.block_input(false)

# key 为 know 与 unknow 来记录状态
func _on_button_pressed(key: String) -> void:
	GlobalFunction.block_input(true)
	var ids = []
	var cards = hand.get_selected_cards()
	for card in cards:
		ids.append(card.id)
	_recored(key, ids)
	await hand.discard_cards(cards)
	await _deal_cards()
	GlobalFunction.block_input(false)

func _on_show_answer_area_entered(area: Area2D) -> void:
	_card_info = SceneManager.call_deferred("popup_view", Const.Views.word_info, false, func(card_info):
		card_info.set_info(area.get_parent().id, Const.Entities.word_card)
		_card_info = card_info
	)

func _on_show_answer_area_exited(_area: Area2D) -> void:
	_card_info.queue_free()

func _on_button_back_pressed() -> void:
	self.queue_free()


func _recored(key: String, ids: Array):
	var data = GlobalStorage.get_value(key, {}) as Dictionary
	for id in ids:
		var _id = str(id)
		if data.has(_id):
			data[_id] = data[_id] + 1
		else:
			data[_id] = 1
	GlobalStorage.save(key, data)
