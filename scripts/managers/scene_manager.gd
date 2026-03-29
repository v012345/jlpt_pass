extends Node

var _back_button = preload("res://base/button_back.tscn")
var scene_layer: Node
var view_layer: CanvasLayer
var popup_layer: CanvasLayer
var notice_layer: CanvasLayer
var current_scene: Node


func _ready() -> void:
	# var className = self.get_script().get_global_name()
	print("SceneMananger Ready!") # output: "MyClass"
## 不可以返回
func change_scene(scene, cb: Callable = Callable()):
	var children = view_layer.get_children()
	for i in range(children.size() - 1, -1, -1):
		children[i].queue_free()
	if scene_layer.is_ancestor_of(EntityManager.player):
			EntityManager.player.get_parent().remove_child(EntityManager.player)
	children = scene_layer.get_children()
	for child in children:
		child.queue_free()
	var new_scene
	if scene is String: new_scene = load(scene).instantiate() # 手动实例化
	elif scene is PackedScene: new_scene = scene.instantiate() # 手动实例化
	assert(new_scene is SceneBase, "change_scene need a SceneBase")
	if cb.is_valid():
		cb.call(new_scene)
	# new_scene.add_child(EntityManager.player)
	scene_layer.add_child(new_scene)
	current_scene = new_scene
	return new_scene

func add_back_button_to_view(view):
	var btn = _back_button.instantiate() as Button
	view.get_node("UILayer").add_child(btn)
	btn.pressed.connect(func(): view.queue_free())


## 在 app 的 view 上打开
func open_view(view, need_back_button: bool = true, cb: Callable = Callable()):
	var view_node
	if view is String: view_node = load(view).instantiate() # 手动实例化
	elif view is PackedScene: view_node = view.instantiate() # 手动实例化
	assert(view_node is ViewBase, "open_view need a ViewBase")
	if need_back_button: add_back_button_to_view(view_node)
	if cb.is_valid():
		cb.call(view_node)
	view_layer.add_child(view_node)
	return view_node

## 在 app 的 Popup 上加入节点
func popup_view(view, need_back_button: bool = true, cb: Callable = Callable()):
	var view_node
	if view is String: view_node = load(view).instantiate() # 手动实例化
	elif view is PackedScene: view_node = view.instantiate() # 手动实例化
	assert(view_node is ViewBase, "popup_view need a ViewBase")
	if need_back_button: add_back_button_to_view(view_node)
	if cb.is_valid():
		cb.call(view_node)
	popup_layer.add_child(view_node)
	return view_node

var _notice_box: PanelContainer
var _notice_label: Label
var _notice_timer: Timer
func _ensure_notice_ui():
	if _notice_box != null and is_instance_valid(_notice_box):
		return

	_notice_box = PanelContainer.new()
	_notice_box.visible = false
	_notice_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_notice_box.anchor_left = 0.5
	_notice_box.anchor_right = 0.5
	_notice_box.anchor_top = 0.38
	_notice_box.anchor_bottom = 0.38
	_notice_box.offset_left = -220
	_notice_box.offset_right = 220
	_notice_box.offset_top = -26
	_notice_box.offset_bottom = 26

	var bg = StyleBoxFlat.new()
	bg.bg_color = Color(0, 0, 0, 0.65)
	bg.corner_radius_top_left = 8
	bg.corner_radius_top_right = 8
	bg.corner_radius_bottom_left = 8
	bg.corner_radius_bottom_right = 8
	_notice_box.add_theme_stylebox_override("panel", bg)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	_notice_box.add_child(margin)

	_notice_label = Label.new()
	_notice_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_notice_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_notice_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_notice_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
	margin.add_child(_notice_label)

	_notice_timer = Timer.new()
	_notice_timer.one_shot = true
	_notice_timer.timeout.connect(func():
		if _notice_box != null and is_instance_valid(_notice_box):
			_notice_box.visible = false
	)

	notice_layer.add_child(_notice_box)
	notice_layer.add_child(_notice_timer)

func show_notice(text, duration = 2.0):
	# UI nodes must be created on the main thread.
	if not Thread.is_main_thread():
		call_deferred("show_notice", text, duration)
		return
	if notice_layer == null:
		push_warning("SceneManager.notice_layer is null, cannot show notice")
		return

	_ensure_notice_ui()
	_notice_label.text = str(text)
	_notice_box.visible = true
	_notice_timer.stop()
	_notice_timer.wait_time = max(0.1, float(duration))
	_notice_timer.start()
