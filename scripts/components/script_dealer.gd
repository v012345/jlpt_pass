extends Node
class_name Dealer

func deal(cards, hand, deck):
	for card in cards:
		# 把牌放到放牌层, 转一下
		self.add_child(card)
		# card.reparent(self)
		card.global_position = deck.global_position
		var to_where = hand.make_space_for_card()
		await card.play_dealing_animation(to_where, hand.sort_hand_use_time)
		hand.insert_cards([card])
