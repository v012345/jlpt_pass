extends BaseHand
signal need_refill_hand(who)


func discard_cards(cards):
	super.discard_cards(cards)
	if self._cards_in_hand.size() <= 0:
		emit_signal("need_refill_hand", self)

func play_question():
	if self._cards_in_hand.size() > 0:
		self._cards_in_hand[0].play_sounds()


func _on_card_clicked(_card) -> void:
	_card.play_sounds()

func _on_card_pressed(_card) -> void:
	pass

func _on_card_release(_card) -> void:
	pass
