extends ViewBase
@export var hero_list: ScrollListBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	hero_list.item_be_clicked.connect(_hero_be_selected)
	var items = []
	var book_list_item = Const.Components.hero_list_item
	for id in [1,2,3,3,4]:
		var item = book_list_item.instantiate()
		#item.init(id)
		items.append(item)
	hero_list.add_items(items)
	pass # Replace with function body.

func _hero_be_selected(book: ScrollListItemBase):
	emit_signal("selet_book", book)
	#if select_callback.is_valid():
		#select_callback.call(book)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
