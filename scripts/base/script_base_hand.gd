extends Control
class_name BaseHand

@export var _crad_space_width: int = 130 ## 牌在手牌中占用的宽度
@export var crad_space_height: int = 190: ## 牌在手牌中占用的宽度
	set(b):
		$Background.size.y = b
		crad_space_height = b
	get: return crad_space_height
@export var sort_hand_use_time: float = 0.2 ## 整理手牌使用的时间

var _cards_in_hand: Array
var _card_position = []
var _selected_cards = []
var _discard_pile

func _ready() -> void:
	pass

var max_cards_in_hand: int = 0:
	set(n):
		max_cards_in_hand = n
		var total_width = _crad_space_width * n
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		var duration = 0.2
		tween.parallel().tween_property($Background, "size:x", total_width, duration)
		tween.parallel().tween_property($Background, "offset_left", -total_width / 2.0, duration)
		tween.parallel().tween_property($Background, "offset_right", total_width / 2.0, duration)
		# print(_card_position)
	get: return max_cards_in_hand

var holding_cards_num: int = 0:
	set(n):
		if holding_cards_num != n:
			holding_cards_num = n
			var middle_index = holding_cards_num / 2.0
			_card_position.resize(n + 1)
			for i in range(n):
				_card_position[i] = _crad_space_width * (i - middle_index + 0.5)
			_card_position[n] = INF
	get: return holding_cards_num


func init(discard_pile, _max_cards_in_hand) -> void:
	self._discard_pile = discard_pile
	self.max_cards_in_hand = _max_cards_in_hand

func make_space_for_card():
	holding_cards_num = holding_cards_num + 1
	_refresh_hand()
	return self.get_global_transform().origin + Vector2(_card_position[holding_cards_num - 1], crad_space_height / 2.0)

func _refresh_hand():
	for i in range(_cards_in_hand.size()):
		var card = _cards_in_hand[i]
		if not card.is_dragging():
			var local_pos: Vector2 = Vector2(_card_position[i], crad_space_height / 2.0)
			if _selected_cards.has(card):
				local_pos += Vector2(0, -20)
			create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT).tween_property(card, "position", local_pos, sort_hand_use_time)
			self.move_child(card, i + 1)


func _on_card_dragging(card) -> void:
	var local_pos = self.get_global_transform_with_canvas().affine_inverse() * card.global_position
	var x = local_pos.x
	var n = _cards_in_hand.size()
	var index = n - 1
	for i in range(n): # 从 0 扫一下, 看一个这个位置, 牌的索引
		var boundary = _card_position[i] + _crad_space_width / 2.0
		if x < boundary:
			index = i
			break
	if _cards_in_hand[index] != card:
		_cards_in_hand.erase(card)
		_cards_in_hand.insert(index, card)
		_refresh_hand()
func burn_cards(cards):
	for card in cards:
		self._cards_in_hand.erase(card)
		holding_cards_num = self._cards_in_hand.size()
		self._selected_cards.erase(card)
		# var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		# tween.tween_property(card, "global_position", _discard_pile.global_position, sort_hand_use_time)
		# await tween.finished
		card.material.set_shader_parameter("show_dissolve", true)
		var tween_destroy = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween_destroy.tween_property(card.material, "shader_parameter/dissolve_value", 0.0, sort_hand_use_time).from(1.0)
		# tween_destroy.parallel().tween_property($Shadow, "self_modulate:a", 0.0, 1.0)
		await tween_destroy.finished
		self.remove_child(card)
		card.queue_free()
		_refresh_hand()

func play_cards(cards):
	if cards.size() <= 0: return
	for card in cards:
		self._cards_in_hand.erase(card)
		holding_cards_num = self._cards_in_hand.size()
		self._selected_cards.erase(card)
	for card in cards:
		self.remove_child(card)
	_refresh_hand()

func discard_cards(cards):
	if cards.size() <= 0: return
	for card in cards:
		self._cards_in_hand.erase(card)
		holding_cards_num = self._cards_in_hand.size()
		self._selected_cards.erase(card)
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	for card in cards:
		tween.parallel().tween_property(card, "global_position", _discard_pile.global_position, sort_hand_use_time)
	await tween.finished
	for card in cards:
		self.remove_child(card)
		card.queue_free()
	_refresh_hand()


func insert_cards(cards) -> void:
	for card in cards:
		card.reparent(self)
		_cards_in_hand.push_back(card)
		holding_cards_num = self._cards_in_hand.size()
		card.card_clicked.connect(self._on_card_clicked)
		card.card_pressed.connect(self._on_card_pressed)
		card.card_release.connect(self._on_card_release)
		card.card_dragging.connect(self._on_card_dragging)
		_refresh_hand()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and not event.pressed:
		_selected_cards.clear()
		_refresh_hand()

func _on_card_clicked(card) -> void:
	if _selected_cards.has(card): _selected_cards.erase(card)
	else: _selected_cards.push_back(card)
	_refresh_hand()

func _on_card_pressed(card) -> void:
	card.z_index = 1
	card.set_collision(true)

func _on_card_release(card) -> void:
	card.set_collision(false)
	card.z_index = 0
	_refresh_hand()

func available_hand_slots() -> int:
	return self.max_cards_in_hand - self._cards_in_hand.size()

func get_all_cards():
	var result = []
	result.append_array(self._cards_in_hand)
	return result

func get_selected_cards():
	var result = []
	result.append_array(self._selected_cards)
	# return self._selected_cards.duplicate() # 这个有 bug , 之后看一下
	return result
