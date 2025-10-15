extends ViewBase
@export var show_log: bool = false
@export var card_num_of_a_deck: int = 20 ## 一副牌的数量
@export var max_cards_in_hand: int = 8 ## 最大手牌数
var card_template: PackedScene = Const.Entities.match_card
@export var dealer: Dealer
@export var discard_pile: Control
@export var deckKana: Control
@export var deck_chinese: Control
@export var hand_top: Control
@export var hand_bottom: Control
var _card_ids
func init(card_ids: Array) -> void:
	self._card_ids = card_ids
	var draw_card_ids: Array = self._card_ids.slice(0, card_num_of_a_deck) # 取前50个
	deckKana.init(draw_card_ids, card_template, "kana")
	deck_chinese.init(draw_card_ids, card_template, "chinese")
	hand_top.init(discard_pile, max_cards_in_hand)
	hand_bottom.init(discard_pile, max_cards_in_hand)
	GlobalFunction.block_input(true)
	await _deal_cards(hand_top, deckKana)
	await _deal_cards(hand_bottom, deck_chinese)
	hand_top.card_be_selected.connect(self._on_card_be_selected)
	hand_bottom.card_be_selected.connect(self._on_card_be_selected)
	hand_top.need_refill_hand.connect(self._on_need_refill_hand)
	hand_bottom.need_refill_hand.connect(self._on_need_refill_hand)
	GlobalFunction.block_input(false)

func _on_need_refill_hand(hand):
	if hand == hand_top:
		await _deal_cards(hand_top, deckKana)
	if hand == hand_bottom:
		await _deal_cards(hand_bottom, deck_chinese)


func _on_card_be_selected():
	var c1 = hand_top.get_selected_cards()
	var c2 = hand_bottom.get_selected_cards()
	if c1.size() > 0 and c2.size() > 0:
		if c1[0].id == c2[0].id:
			await hand_top.discard_cards(c1)
			await hand_bottom.discard_cards(c2)

func _restart() -> void:
	self._card_ids.shuffle()
	var draw_card_ids: Array = self._card_ids.slice(0, card_num_of_a_deck) # 取前50个
	deckKana.init(draw_card_ids, card_template, "kana")
	deck_chinese.init(draw_card_ids, card_template, "chinese")
	GlobalFunction.block_input(true)
	await _deal_cards(hand_top, deckKana)
	await _deal_cards(hand_bottom, deck_chinese)
	GlobalFunction.block_input(false)

func _deal_cards(hand, deck):
	if max(hand.holding_cards_num, deck.get_card_num()) <= 0:
		if hand == hand_bottom:
			PopupManager.popup(self, Const.Views.two_buttons, true, func(two_buttons):
				two_buttons.button_top.text = "再来一局"
				two_buttons.button_top.pressed.connect(func(): _restart(); two_buttons.queue_free())
				two_buttons.button_bottom.text = "返回"
				two_buttons.button_bottom.pressed.connect(queue_free)
			)
			return
	# 拿缺少的手牌数或剩下的所有牌
	var cards = deck.draw_cards(min(hand.available_hand_slots(), deck.get_card_num()))
	# 发牌
	cards.shuffle()
	cards.shuffle()
	await dealer.deal(cards, hand, deck)
