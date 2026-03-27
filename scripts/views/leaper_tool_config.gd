extends ViewBase

@export var toolPath:LineEdit
@export var xlsxPath:LineEdit
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toolPath.text = GlobalStorage.get_value("leaper_tools","")
	xlsxPath.text = GlobalStorage.get_value("leaper_xlsx","")
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_xlsx_to_json_pressed() -> void:
	print(toolPath.text)
	var output = []
	var exit_code = OS.execute("py", [toolPath.text+"\\leaper_xslx_to_json_for_godot.py", "--xlsx",xlsxPath.text + "\\HeroList.xlsx", "--json",ProjectSettings.globalize_path("user://")+"HeroList.json"], output)
	print("exit_code:", exit_code)
	print("output:", output)
	pass # Replace with function body.


func _on_tool_path_text_submitted(new_text: String) -> void:
	GlobalStorage.save("leaper_tools", toolPath.text)
	pass # Replace with function body.


func _on_tool_path_focus_exited() -> void:
	GlobalStorage.save("leaper_tools", toolPath.text)
	pass # Replace with function body.


func _on_xlsx_path_focus_entered() -> void:
	GlobalStorage.save("leaper_xlsx", xlsxPath.text)
	pass # Replace with function body.


func _on_xlsx_path_text_submitted(new_text: String) -> void:
	GlobalStorage.save("leaper_xlsx", xlsxPath.text)
	pass # Replace with function body.


func _on_button_json_to_xlsx_pressed() -> void:
	print(toolPath.text)
	var output = []
	var exit_code = OS.execute("py", [toolPath.text+"\\leaper_json_to_xslx_to_for_game.py", "--xlsx",xlsxPath.text + "\\HeroList.xlsx", "--json",ProjectSettings.globalize_path("user://")+"HeroList.json"], output)
	print("exit_code:", exit_code)
	print("output:", output)
	pass # Replace with function body.
