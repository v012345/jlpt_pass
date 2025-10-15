extends BaseCard
class_name MatchCard

# gui 的 event.position 是 local 的位置
func _on_touch_layer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			GlobalFunction.print_log(self.show_log, [self.id, "鼠标按下"])
			emit_signal("card_pressed", self)
			emit_signal("card_clicked", self)
			self._is_pressed = true
			self._pos_offset = global_position - get_global_mouse_position()
			self._pos_pressed = get_global_mouse_position()
			self._time_pressed = Time.get_ticks_msec()
		else:
			GlobalFunction.print_log(self.show_log, [self.id, "鼠标松开"])
			self._is_pressed = false
			emit_signal("card_release", self)
