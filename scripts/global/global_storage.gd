extends Node

var data
var path: String = "user://GlobalStorage.json"
var file: FileAccess

func _ready() -> void:
	if not FileAccess.file_exists(path):
		file = FileAccess.open(path, FileAccess.WRITE)
		file.store_string(JSON.stringify({}))
		file.close()
	file = FileAccess.open(path, FileAccess.READ)
	self.data = JSON.parse_string(file.get_as_text())
	print("Storage Ready!")

func save(key:String, value) -> void:
	self.data[key] = value
	file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(self.data))
	file.close()
	
func get_value(key, default_value = null):
	if self.data.has(key):
		return self.data[key]
	return default_value
