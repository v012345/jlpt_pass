extends DataModelBase
class_name LeaperConfigModel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func getPythonScriptPath():
	return "D:/NightOwlToolsV2/tool_scripts/Python/"

func getLeaperTablesPath():
	return "C:/Users/NightOwl/Desktop/tables/"

func getLeaperAssetsPath():
	return "C:/Users/NightOwl/Desktop/work/leaper-code/assets/"

func getLeaperTables():
	return ["HeroList", "ItemList", "Text", "HeroSkillUnLock", "RewardNew"]

func initLeaperModels():
	Model.LeaperHerosModel.init()
