extends BaseCard
class_name WordCard
var _is_show_chinese = false
var _sound_progress_tween

func _ready() -> void:
	super._ready()
	$FlapTimer.timeout.connect(func():
		if self._is_show_chinese: play_change_text_animation(0.5)
	)

func play_change_text_animation(duration):
	self.is_playing_animation = true
	_is_show_chinese = not _is_show_chinese
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	self.material.set_shader_parameter("fov", 16) # 16 测试效果比较好
	tween.parallel().tween_property(self.material, "shader_parameter/y_rot", -89, duration / 2)
	await tween.finished
	if _is_show_chinese: 
		self.word.text = GlobalDb.words.japanese[self.id]["kanji"]
	else: 
		self.word.text = GlobalDb.words.japanese[self.id]["kana"]
		self.stop_play_segments()
	sound_progress.visible = _is_show_chinese
	playing_sound.visible = _is_show_chinese
	self.material.set_shader_parameter("y_rot", 89)
	tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self.material, "shader_parameter/y_rot", 0, duration / 2)
	# # # 发完成, 归正
	await tween.finished
	self.material.set_shader_parameter("fov", 90)
	self.is_playing_animation = false

func play_sounds():
	var info = GlobalDb.words.japanese[self.id]
	var duration = 0.5
	var sounds = [ {
			"path": info["sound_file"],
			"sound_start": info["sound_start"],
			"sound_end": info["sound_end"],
		}]
	duration += info["sound_end"] - info["sound_start"]
	for example_id in info["example_id"]:
		var example_info = GlobalDb.words.example[example_id]
		sounds.append({
			"path": example_info["sound_file"],
			"sound_start": example_info["sound_start"],
			"sound_end": example_info["sound_end"],
		})
		duration += example_info["sound_end"] - example_info["sound_start"]
	self.play_segments(sounds)
	$FlapTimer.wait_time = duration + 0.2
	$FlapTimer.start()
	GlobalFunction.kill_tween(_sound_progress_tween)
	sound_progress.value = 100
	_sound_progress_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(true)
	_sound_progress_tween.tween_property(sound_progress, "value", 0, duration)
