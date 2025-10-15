extends Control
class_name ScrollListItemBase
var father_container:ScrollListBase

## 如果被重写, 不要需要自己调用 father_container.be_clicked(self)
#func _on_button_be_clicked_pressed() -> void:
	## do something
	#father_container.be_clicked(self)
