extends ScrollContainer
class_name ScrollListBase
@export var container: Container

signal item_be_clicked(item: ScrollListItemBase)

func add_items(items: Array):
	for item in items:
		item.father_container = self
		if not item.has_method("_on_button_be_clicked_pressed"):
			var btn_cb = item.get_node("%ButtonBeClicked") as Button
			btn_cb.pressed.connect(func(): be_clicked(item))
		container.add_child(item)

func be_clicked(item: ScrollListItemBase):
	emit_signal("item_be_clicked", item)
