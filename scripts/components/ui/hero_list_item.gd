extends ScrollListItemBase

var id: String
@export var hero_name:Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init(id: String):
	hero_name.text = GlobalDb.leaper_tables["HeroList"][id]["Name"]
	# print(GlobalDb.leaper_tables["HeroList"][id]["Name"])
	self.id = id


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
