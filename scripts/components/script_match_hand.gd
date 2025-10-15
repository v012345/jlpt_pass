extends BaseHand
class_name MatchHand

signal card_be_selected() ## 被点击
signal need_refill_hand(who)


func discard_cards(cards):
	await super.discard_cards(cards)
	if self._cards_in_hand.size() <= 0:
		emit_signal("need_refill_hand", self)


func insert_cards(cards) -> void:
	super.insert_cards(cards)
	for card in cards:
		card.card_pressed.disconnect(self._on_card_pressed)
		card.card_release.disconnect(self._on_card_release)
		card.card_dragging.disconnect(self._on_card_dragging)

func _on_card_clicked(card) -> void:
	if _selected_cards.has(card):
		_selected_cards.clear()
		card.glowing = false
	else:
		for c in _selected_cards:
			c.glowing = false
		_selected_cards.clear()
		_selected_cards.push_back(card)
		card.glowing = true
		emit_signal("card_be_selected")
	_refresh_hand()
