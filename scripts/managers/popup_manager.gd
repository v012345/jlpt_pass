# 每个场景对应一个弹窗实例队列, 当队列头弹窗释放后, 弹出一下弹窗
# 当场景退出时, 释放队列中的所以实例
extends Node

var _scene_popup_map_queue = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# var className = self.get_script().get_global_name()
	print("PopupMananger Ready!") # output: "MyClass"

func _on_scene_node_tree_exited(scene_node):
	var popup_queue = _scene_popup_map_queue[scene_node] as Array
	while popup_queue.size() > 0:
		var popup_node = popup_queue.pop_back()
		if is_instance_valid(popup_node):
			popup_node.tree_exited.disconnect(self._on_popup_node_tree_exited)
			popup_node.queue_free()
	_scene_popup_map_queue.erase(scene_node)

func _on_popup_node_tree_exited(scene_node, popup_node):
	var popup_queue = _scene_popup_map_queue[scene_node] as Array
	if popup_queue[0] == popup_node:
		popup_queue.erase(popup_node)
		var valid_popup_node = _get_one_valid_popup_node(scene_node)
		if valid_popup_node:
			scene_node.get_node("SubView").call_deferred("add_child", valid_popup_node)
	else:
		popup_queue.erase(popup_node)

func _get_one_valid_popup_node(scene_node):
	var valid_popup_node = null
	var popup_queue = _scene_popup_map_queue[scene_node] as Array
	while popup_queue.size() > 0:
		var popup_node = popup_queue[0]
		if is_instance_valid(popup_node):
			valid_popup_node = popup_node
			break
		else:
			popup_queue.pop_front()
	return valid_popup_node
	

func _add_mask(popup_node):
	var mask = ColorRect.new()
	mask.color = Color(0, 0, 0, 0.5) # 半透明黑
	mask.anchor_left = 0
	mask.anchor_top = 0
	mask.anchor_right = 1
	mask.anchor_bottom = 1
	mask.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mask.size_flags_vertical = Control.SIZE_EXPAND_FILL
	mask.mouse_filter = Control.MOUSE_FILTER_STOP # 防止点击穿透

	# 插到子节点最前面，确保它在最下面
	popup_node.add_child(mask)
	popup_node.move_child(mask, 0)


## 在当前节点的 SubView 上加入节点
func popup(current_node: ViewBase, path, need_mask: bool = true, cb: Callable = Callable()):
	var _popup
	if path is String: _popup = load(path).instantiate() # 手动实例化
	elif path is PackedScene: _popup = path.instantiate() # 手动实例化
	# 确认 _popup 是 Control（或派生类），否则加不进去
	if need_mask and _popup is Control:
		_add_mask(_popup)
	if cb.is_valid():
		cb.call(_popup)
	# popup_layer.add_child(_popup)
	if not current_node.tree_exited.is_connected(self._on_scene_node_tree_exited):
		current_node.tree_exited.connect(self._on_scene_node_tree_exited.bind(current_node))
	_popup.tree_exited.connect(self._on_popup_node_tree_exited.bind(current_node, _popup))

	if not _scene_popup_map_queue.has(current_node):
		_scene_popup_map_queue[current_node] = []
	var popup_queue = _scene_popup_map_queue[current_node] as Array
	if popup_queue.size() <= 0:
		current_node.get_node("SubView").call_deferred("add_child", _popup)
	popup_queue.push_back(_popup)
	return _popup
