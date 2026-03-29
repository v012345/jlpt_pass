extends ViewBase
@export var hero_list: ScrollListBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	hero_list.item_be_clicked.connect(_hero_be_selected)
	var items = []
	var hero_list_item = Const.Components.hero_list_item
	for id in Model.LeaperHerosModel.getAllHeroIds():
		var item:HeroListItem = hero_list_item.instantiate()
		item.init(id)
		items.append(item)
	hero_list.add_items(items)
	pass # Replace with function body.

func _hero_be_selected(hero: ScrollListItemBase):
	SceneManager.open_view(Const.Views.hero_info).init(hero.id)
