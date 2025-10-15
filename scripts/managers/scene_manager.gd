extends Node

var _back_button = preload("res://base/button_back.tscn")
var scene_layer: Node
var view_layer: CanvasLayer
var popup_layer: CanvasLayer
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
	new_scene.add_child(EntityManager.player)
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
