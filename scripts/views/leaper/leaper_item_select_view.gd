extends ViewBase
class_name LeaperItemSelectView

@export var item_list: ScrollListBase
var select_item_callback: Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	item_list.item_be_clicked.connect(_hero_be_selected)
	var items = []
	var hero_list_item = Const.Components.hero_list_item
	for id in Model.LeaperHerosModel.getAllHeroIds():
		var item: HeroListItem = hero_list_item.instantiate()
		item.init(id)
		items.append(item)
	item_list.add_items(items)
	pass # Replace with function body.

func _hero_be_selected(hero: ScrollListItemBase):
	pass
	#SceneManager.open_view(Const.Views.hero_info).init(hero.id)

func set_select_item_callback(callback: Callable = Callable()):
	select_item_callback = callback

func _on_button_confirm_pressed() -> void:
	if select_item_callback.is_valid():
		select_item_callback.call("1001")
	queue_free()
	pass # Replace with function body.

func _on_button_cancel_pressed() -> void:
	queue_free()
	pass # Replace with function body.
