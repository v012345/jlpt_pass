extends Node
var words = {
	"japanese" : preload("res://scripts/db/words/japanese.gd").DATA,
	"example" : preload("res://scripts/db/words/example.gd").DATA,
	"books" : preload("res://scripts/db/words/books.gd").DATA
}
func _ready() -> void:
	print("DB Ready!")
