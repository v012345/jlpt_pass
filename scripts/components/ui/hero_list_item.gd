extends ScrollListItemBase
class_name HeroListItem
var id: String
@export var hero_name: Label
@export var hero_icon: TextureRect
@export var is_selected: TextureRect
var image: Image

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init(_id: String):
	id = _id
	image = Image.new()
	hero_name.text = Model.LeaperHerosModel.getHeroNameById(id)
	if image.load(Model.LeaperHerosModel.getHeroIconById(id)) == OK:
		hero_icon.texture = ImageTexture.create_from_image(image)
	#GlobalDb.leaper_tables["HeroList"][id]["Name"]
	# print(GlobalDb.leaper_tables["HeroList"][id]["Name"])

func setSelect(b:bool):
	is_selected.visible = b
func isSelect()-> bool: 
	return is_selected.visible
