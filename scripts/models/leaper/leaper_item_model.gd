extends DataModelBase
class_name LeaperItemModel


class ItemData:
	var Id: String
	var NameId: String
	var Icon: String
	var Rarity: int
	var Type: int
	var DescId: String

	static func from_dict(d: Dictionary) -> ItemData:
		var item = ItemData.new()
		item.Id = d.get("Id", "")
		item.NameId = d.get("Name", "")
		item.Rarity = d.get("Rarity", 0)
		item.Type = d.get("Type", 0)
		item.Icon = d.get("Icon", "")
		item.DescId = d.get("DescId", "")
		return item

var data: Dictionary

func init():
	var file = FileAccess.open("user://ItemList.json", FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(text)
	if parsed is Dictionary:
		for id in parsed:
			data[id] = ItemData.from_dict(parsed[id])

func getAllHeroIds() -> Array:
	return data.keys()

func getHeroDataById(id: String) -> ItemData:
	return data.get(id, null)

func getHeroNameById(id: String) -> String:
	var hero = getHeroDataById(id)
	if hero:
		return hero.Name
	return ""

func getHeroIconById(id: String) -> String:
	var hero = getHeroDataById(id)
	if hero:
		return Model.LeaperConfigModel.getLeaperAssetsPath()+"remoteBundle/game_asset/" + hero.Icon + ".png"
	return ""
