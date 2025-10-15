extends Control
class_name Deck
var _cards_in_deck: Array ## 牌堆里的牌
var adjacent: float = 6 ## 牌堆里的牌

func init(card_ids: Array, card_type: PackedScene, show_what: String) -> void:
	GlobalFunction.remove_all_children(self)
	_cards_in_deck.clear()
	for i in range(card_ids.size()):
		var card: BaseCard = card_type.instantiate()
		card.init(card_ids[i], show_what)
		self.add_child(card)
		card.position = Vector2(i / adjacent, -i / adjacent)
		_cards_in_deck.push_back(card)

func insert_cards(cards):
	for card in cards:
		_cards_in_deck.append(card)
		self.add_child(card)

func get_all_cards():
	return _cards_in_deck

func refresh():
	GlobalFunction.remove_all_children(self)
	for i in range(_cards_in_deck.size()):
		var card = _cards_in_deck[i]
		self.add_child(card)
		card.position = Vector2(i / adjacent, -i / adjacent)

# 牌堆里有多少张牌
func get_card_num() -> int:
	return _cards_in_deck.size()

# 从牌堆里抽 num 张牌
func draw_cards(num) -> Array:
	var cards = []
	for i in range(num):
		var card = _cards_in_deck.pop_back()
		self.remove_child(card)
		cards.push_back(card)
	return cards
