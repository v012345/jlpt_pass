extends DataModelBase
class_name LeaperTextModel

class TextData:
	var Id: String
	var Text: String

	static func from_dict(d: Dictionary) -> TextData:
		var text = TextData.new()
		text.Id = d.get("Id", "")
		text.Text = d.get("Text", "")
		return text

var data: Dictionary

func init():
	var file = FileAccess.open("user://Text.json", FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(text)
	if parsed is Dictionary:
		for id in parsed:
			data[id] = TextData.from_dict(parsed[id])

func getTextById(id:String)->String:
	return data.get(id,null).Text
