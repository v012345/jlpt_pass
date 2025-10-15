extends BaseCard

var _sound_progress_tween

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
	GlobalFunction.kill_tween(_sound_progress_tween)
	sound_progress.value = 100
	_sound_progress_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(true)
	_sound_progress_tween.tween_property(sound_progress, "value", 0, duration)
