extends Node
class_name App

var sounds_queue: Array

func _ready() -> void:
	# print_stack()
	var timer = $AudioStreamPlayer.get_node("Timer")
	timer.timeout.connect(func():
		$AudioStreamPlayer.stop()
		if sounds_queue.size() > 0:
			var sound = sounds_queue.pop_front()
			_play_segment(sound["path"], sound["sound_start"], sound["sound_end"])
		
		)
	GlobalFunction.app = self
	SceneManager.scene_layer = $Scene
	SceneManager.view_layer = $View
	SceneManager.popup_layer = $Popup
	Const.Scenes = $Scenes
	Const.Views = $Views
	Const.Components = $Components
	Const.Entities = $Entities
	_register_models()
	EntityManager.create_player()
	SceneManager.change_scene(Const.Scenes.balatro)
	print("App Ready!")
	
func _register_models():
	Model.JapaneseModel = $Models.japanese_model.instantiate()
	Model.add_child(Model.JapaneseModel)

func _play_segment(path: String, start_time: float, end_time: float):
	var player = $AudioStreamPlayer
	player.stop()
	var timer = $AudioStreamPlayer.get_node("Timer")
	var duration = max(0.01, end_time - start_time)
	timer.one_shot = true
	timer.wait_time = duration
	timer.start()
	var stream: AudioStream = load(path)
	if stream == null: return
	player.stream = stream
	player.play(start_time) # 从 start_time 秒开始播放


func play_segments(sounds):
	var sound = sounds.pop_front()
	_play_segment(sound["path"], sound["sound_start"], sound["sound_end"])
	sounds_queue = sounds
	
func block_input(b: bool):
	%InputBlocking.visible = b
