extends ViewBase
@export var book_list: ScrollListBase
signal selet_book(book: ScrollListItemBase)
var select_callback: Callable
func _ready() -> void:
	super._ready()
	book_list.item_be_clicked.connect(_book_be_selected)

func _book_be_selected(book: ScrollListItemBase):
	emit_signal("selet_book", book)
	if select_callback.is_valid():
		select_callback.call(book)

## cb 选中回调
func set_info(book_ids: Array, cb: Callable = Callable()):
	var items = []
	var book_list_item = Const.Components.book_list_item
	for id in book_ids:
		var item = book_list_item.instantiate()
		item.init(id)
		items.append(item)
	book_list.add_items(items)
	select_callback = cb

func _unhandled_key_input(event: InputEvent) -> void:
	if event.keycode == KEY_ESCAPE and event.is_pressed():
		_on_button_back_pressed()
	get_viewport().set_input_as_handled()


func _on_button_back_pressed() -> void:
	self.queue_free()
