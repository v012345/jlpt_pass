extends ScrollListItemBase
@export var cover: TextureRect

var id: int
func init(_id: int):
	self.id = _id
	cover.texture = load(GlobalDb.words.books[_id].cover)

func _on_button_be_clicked_mouse_entered() -> void:
	cover.scale = Vector2.ONE * 1.1


func _on_button_be_clicked_mouse_exited() -> void:
	cover.scale = Vector2.ONE
