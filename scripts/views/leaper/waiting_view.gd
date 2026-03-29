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
	# WorkerThreadPool.add_task(func(): pass)
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

	call_deferred("_update_message_label", "正在解析 Tables...")

	output.clear()
	exit_code = OS.execute("py", ["-X", "utf8",
		Model.LeaperConfigModel.getPythonScriptPath() + "leaper_xslx_to_json_for_godot.py",
		"--xlsx", Model.LeaperConfigModel.getLeaperTablesPath() + "HeroList.xlsx",
		"--json", ProjectSettings.globalize_path("user://") + "HeroList.json"], output, true
	)
	print("exit_code:", exit_code)
	if exit_code != 0:
		SceneManager.show_notice("HeroList 解析失败", 9999)
		print(output)
		return
	call_deferred("_start_progress_tween", 30)

	output.clear()
	exit_code = OS.execute("py", ["-X", "utf8",
		Model.LeaperConfigModel.getPythonScriptPath() + "leaper_xslx_to_json_for_godot.py",
		"--xlsx", Model.LeaperConfigModel.getLeaperTablesPath() + "ItemList.xlsx",
		"--json", ProjectSettings.globalize_path("user://") + "ItemList.json"], output, true
	)
	if exit_code != 0:
		SceneManager.show_notice("ItemList 解析失败", 9999)
		return

	call_deferred("_start_progress_tween", 100)
	call_deferred("_on_task_done")

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
	self.queue_free()
	# label.text = "完成了"

func _exit_tree():
	timer.stop()
	if thread:
		thread.wait_to_finish()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
