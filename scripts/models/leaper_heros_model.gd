extends DataModelBase
class_name LeaperHerosModel

class HeroData:
	var Id: String
	var Name: String
	var Model: String
	var Icon: String
	var Rarity: int
	var Type: int
	var UpLvMaterials: Array
	var UpLvCost: Array
	var MaxLevel: int

	static func from_dict(d: Dictionary) -> HeroData:
		var hero = HeroData.new()
		hero.Id = d.get("Id", "")
		hero.Name = d.get("Name", "")
		hero.Model = d.get("Model", "")
		hero.Rarity = d.get("Rarity", 0)
		hero.Type = d.get("Type", 0)
		hero.UpLvMaterials = d.get("UpLvMaterials", [])
		hero.UpLvCost = d.get("UpLvCost", [])
		hero.MaxLevel = d.get("MaxLevel", 0)
		hero.Icon = d.get("Icon", "")
		return hero

var data: Dictionary

func init():
	var file = FileAccess.open("user://HeroList.json", FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(text)
	if parsed is Dictionary:
		for id in parsed:
			data[id] = HeroData.from_dict(parsed[id])

func getAllHeroIds() -> Array:
	return data.keys()

func getHeroDataById(id: String) -> HeroData:
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
