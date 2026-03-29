extends ViewBase

@export var tree: Tree
@export var hero_name: Label
@export var hero_id: Label
@export var material1: LineEdit
@export var material2: LineEdit
@export var material3: LineEdit
@export var costCofig: TextEdit
@export var hero_class_options: OptionButton
@export var hero_rarity_options: OptionButton
@export var hero_icon: TextureRect
@export var max_level: LineEdit

var current_hero_id := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.tree.columns = 4
	tree.set_column_titles_visible(true)
	tree.set_hide_root(true)
	tree.set_column_title(0, "Level")
	tree.set_column_title(1, " 材料1 ")
	tree.set_column_title(2, " 材料2 ")
	tree.set_column_title(3, " 材料3 ")
	hero_class_options.get_popup().add_theme_constant_override("icon_max_width", 26)
	pass # Replace with function body.

func init(id: String):
	var hero_data = Model.LeaperHerosModel.getHeroDataById(id)
	hero_id.text = "ID: %s" % id
	hero_name.text = "名字 : %s" % hero_data.Name
	hero_class_options.selected = hero_data.Type - 1
	hero_rarity_options.selected = hero_data.Rarity - 1
	var image = Image.new()
	image.load(Model.LeaperHerosModel.getHeroIconById(id))
	hero_icon.texture = ImageTexture.create_from_image(image)
	max_level.text = str(hero_data.MaxLevel)
	current_hero_id = id
	var m = hero_data.UpLvMaterials
	material1.text = str(m[0]) if m.size() > 0 else "0"
	material2.text = str(m[1]) if m.size() > 1 else "0"
	material3.text = str(m[2]) if m.size() > 2 else "0"
	var upLvCost = hero_data.UpLvCost
	
	tree.clear()
	var root = self.tree.create_item()
	for i in range(1, hero_data.MaxLevel + 1):
		var item = tree.create_item(root)
		item.set_text(0, "Lv.%d" % i)
		item.set_editable(1, true)
		item.set_editable(2, true)
		item.set_editable(3, true)
		item.set_text_alignment(1, HORIZONTAL_ALIGNMENT_CENTER)
		item.set_text_alignment(2, HORIZONTAL_ALIGNMENT_CENTER)
		item.set_text_alignment(3, HORIZONTAL_ALIGNMENT_CENTER)
		if upLvCost.size() >= i:
			item.set_text(1, str(int(upLvCost[i - 1][0])))
			item.set_text(2, str(int(upLvCost[i - 1][1])))
			item.set_text(3, str(int(upLvCost[i - 1][2])))
			pass
		else:
			item.set_text(1, "0")
			item.set_text(2, "0")
			item.set_text(3, "0")



func _on_button_parse_pressed() -> void:
	print(costCofig.text)
	var result = []
	var lines = costCofig.text.strip_edges().split("\n")
	for line in lines:
		if line.strip_edges() == "":
			continue
		var cols = line.split("\t")
		var row = []
		for c in cols:
			row.append(c) # 转 int
		result.append(row)
	var root = tree.get_root()
	if root == null:
		return

	var item = root.get_first_child()
	var index = 0
	while item != null and index < result.size():
		item.set_text(1, result[index][0] if result[index].size() > 0 else "0")
		item.set_text(2, result[index][1] if result[index].size() > 1 else "0")
		item.set_text(3, result[index][2] if result[index].size() > 2 else "0")
		item = item.get_next()
		index += 1
	pass # Replace with function body.


func _text_to_int(text: String) -> int:
	var value = text.strip_edges()
	return int(value) if value.is_valid_int() else 0


func _on_button_apply_all_pressed() -> void:
	var hero_list = GlobalDb.leaper_tables["HeroList"]
	if hero_list == null:
		return

	var root = tree.get_root()
	if root == null:
		return

	var up_lv_cost = []
	var item = root.get_first_child()
	while item != null:
		up_lv_cost.append([
			_text_to_int(item.get_text(1)),
			_text_to_int(item.get_text(2)),
			_text_to_int(item.get_text(3))
		])
		item = item.get_next()

	for hero_key in hero_list.keys():
		hero_list[hero_key]["UpLvCost"] = up_lv_cost.duplicate(true)

	GlobalDb.save_leaper_table("HeroList", hero_list)
