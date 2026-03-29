extends ViewBase
class_name WaitingView

@export var dot_label: Label
@export var timer: Timer
@export var progress_bar: ProgressBar
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
	var exit_code = OS.execute("py", ["--version"], output)
	if exit_code != 0:
		print("Python 未安装或未添加到环境变量")
		return
	SceneManager.show_notice("Python 已安装，正在处理数据...",100000)
	return
	print("exit_code:", exit_code)
	print("output:", output)

	# 模拟耗时操作
	for i in range(5):
		OS.delay_msec(1000)
		print("处理中: ", i)

	print("线程结束")
	call_deferred("_on_task_done")

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
