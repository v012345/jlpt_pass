extends BaseHand
class_name WordHand



# func insert_cards(cards) -> void:
# 	super.insert_cards(cards)
# 	for card in cards:
# 		card.card_double_clicked.connect(self._on_card_double_clicked)

# func _on_card_double_clicked(card):
# 	if card.is_playing_animation: return
# 	card.play_change_text_animation(0.5)
# 	if card._is_show_chinese:
# 		for c in _cards_in_hand:
# 			if card != c and  c._is_show_chinese:
# 				c.play_change_text_animation(0.5)
# 		card.play_sounds()

func _on_card_clicked(card) -> void:
	if card.is_playing_animation: return
	card.play_change_text_animation(0.5)
	if card._is_show_chinese:
		for c in _cards_in_hand:
			if card != c and c._is_show_chinese:
				c.play_change_text_animation(0.5)
		card.play_sounds()
