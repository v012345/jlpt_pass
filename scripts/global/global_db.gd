extends Node
var words = {
	"japanese" : preload("res://scripts/db/words/japanese.gd").DATA,
	"example" : preload("res://scripts/db/words/example.gd").DATA,
	"books" : preload("res://scripts/db/words/books.gd").DATA
}
var leaper_tables = {
	"HeroList" : {}
}
func _ready() -> void:
	var file = FileAccess.open("user://HeroList.json", FileAccess.READ)
	if file != null:
		var text = file.get_as_text()
		leaper_tables["HeroList"] = JSON.parse_string(text)
	
	print("DB Ready!")

func reload():
	var file = FileAccess.open("user://HeroList.json", FileAccess.READ)
	if leaper_tables["HeroList"] == null:
		print("文件打开失败:", file)
	# # 2. 读取文本
	var text = file.get_as_text()
	file.close()
	# # 3. 解析 JSON
	leaper_tables["HeroList"] = JSON.parse_string(text)
	# words = {
	# 	"japanese" : preload("res://scripts/db/words/japanese.gd").DATA,
	# 	"example" : preload("res://scripts/db/words/example.gd").DATA,
	# 	"books" : preload("res://scripts/db/words/books.gd").DATA
	# }

func save_leaper_table(table_name: String, data):
	var path = "user://%s.json" % table_name
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print("文件打开失败:", path)
		return
	var json = JSON.stringify(data)
	file.store_string(json)
	file.close()
