extends ViewBase

@export var hero_list: ScrollListBase
var select_item_callback: Callable
var items = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.

func init(selected_hero_ids: Array):
	hero_list.item_be_clicked.connect(_hero_be_selected)
	var hero_list_item = Const.Components.hero_list_item
	for id in Model.LeaperHerosModel.getAllHeroIds():
		var item: HeroListItem = hero_list_item.instantiate()
		item.init(id)
		items.append(item)
	hero_list.add_items(items)
	
	for item in items:
		if selected_hero_ids.has(item.id):
			item.setSelect(true)
	return self

func set_select_item_callback(callback: Callable = Callable()):
	select_item_callback = callback

func _on_button_confirm_pressed() -> void:
	if select_item_callback.is_valid():
		var selected_hero_ids = []
		for item in items:
			if item.isSelect():
				selected_hero_ids.append(item.id)
		select_item_callback.call(selected_hero_ids)
	queue_free()
	pass # Replace with function body.

func _hero_be_selected(hero: ScrollListItemBase):
	hero.setSelect(!hero.isSelect())
	# SceneManager.open_view(Const.Views.hero_info).init(hero.id)

func _on_button_cancel_pressed() -> void:
	queue_free()
	pass # Replace with function body.
