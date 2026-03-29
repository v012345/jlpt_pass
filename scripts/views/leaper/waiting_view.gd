extends ViewBase
class_name WaitingView

@export var dot_label: Label
@export var timer: Timer
@export var progress_bar: ProgressBar
@export var message_label: Label
var x = 1
var thread: Thread
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	progress_bar.value = 0
	self.dot_label.text = ".".repeat(x)
	timer.timeout.connect(func():
		self.dot_label.text = ".".repeat(x)
		x += 1
		if x >= 30: x = 1
	)
	thread = Thread.new()
	# WorkerThreadPool.add_task(_thread_func)
	thread.start(_thread_func)
	pass # Replace with function body.

func _thread_func():
	print("线程开始")
	# check py
	var output = []
	var exit_code = OS.execute("py", ["-X", "utf8", "--version"], output, true)

	call_deferred("_update_message_label", "正在检查 Python 环境...")
	if exit_code != 0:
		SceneManager.show_notice("Python 未安装或未添加到环境变量", 9999)
		return
	call_deferred("_start_progress_tween", 10)

	call_deferred("_update_message_label", "正在检查需要 Python 包...")
	output.clear()
	exit_code = OS.execute("py", ["-X", "utf8", Model.LeaperConfigModel.getPythonScriptPath() + "\\leaper_check_necessary_package.py"], output, true)
	if exit_code != 0:
		SceneManager.show_notice("leaper_check_necessary_package 运行失败", 9999)
		return
	call_deferred("_update_message_label", "leaper_check_necessary_package 运行成功")
	call_deferred("_start_progress_tween", 20)
	var all_tables = Model.LeaperConfigModel.getLeaperTables()
	for i in range(all_tables.size()):
		var table_name = all_tables[i]
		call_deferred("_update_message_label", "正在解析 %s" % table_name)
		if not _parse_table(table_name): return
		call_deferred("_start_progress_tween", 20.0 + (i + 1.0) / all_tables.size() * 80)
	call_deferred("_on_task_done")

func _parse_table(table_name: String):
	var output = []
	var exit_code = OS.execute("py", ["-X", "utf8",
		Model.LeaperConfigModel.getPythonScriptPath() + "leaper_xslx_to_json_for_godot.py",
		"--xlsx", Model.LeaperConfigModel.getLeaperTablesPath() + "%s.xlsx" % table_name,
		"--json", ProjectSettings.globalize_path("user://") + "%s.json" % table_name], output, true
	)
	if exit_code != 0:
		SceneManager.show_notice("%s 解析失败" % table_name, 9999)
		return false
	return true

func _start_progress_tween(progress: float):
	if not is_instance_valid(progress_bar):
		return
	var tween := create_tween()
	tween.tween_property(progress_bar, "value", progress, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func _update_message_label(text: String):
	if not is_instance_valid(message_label):
		return
	message_label.text = text

func _on_task_done():
	Model.LeaperConfigModel.initLeaperModels()
	self.queue_free()
	# label.text = "完成了"

func _exit_tree():
	timer.stop()
	# if thread:
	# 	thread.wait_to_finish()
