extends Node2D
class_name BaseCard

@export var show_log: bool = false ## 是否显示 log
@export var scale_on_hover: float = 1.05 ## 当鼠标悬停在牌上时, 牌放大的系数
@export var collision_area: CollisionShape2D ## 卡牌的碰撞区域
@export var word: Label ## 显示文字的 Label
@export var sound_progress: ProgressBar
@export var playing_sound: AnimatedSprite2D
@export var icon: Sprite2D


signal card_clicked(c) ## 被点击
signal card_double_clicked(c) ## 被点击
signal card_pressed(c) ## 被按下
signal card_release(c) ## 被松开
signal card_dragging(c) ## 正在拖拽

var id: int ## 本牌的 id
var _is_pressed: bool = false ## 鼠标是不是正在按住牌
var _pos_offset: Vector2 ## 牌中心相对鼠标的位移
var _pos_pressed: Vector2 ## 当鼠标点击牌时, 牌的位置
var _time_pressed: float ## 当鼠标点击牌的时刻
var _time_released: float ## 当鼠标点击牌的时刻
var _is_front: bool ## 是不是显示正面
var life := 0.0 ## 已存活时间
var is_playing_animation: bool = false

var sounds_queue: Array

# var _can_be_dragged: bool = true:
# 	set = _set_can_be_dragged,
# 	get = _get_can_be_dragged

# func _set_can_be_dragged(args):
# 	_can_be_dragged = args

# func _get_can_be_dragged():
# 	return _can_be_dragged

@export var can_be_dragged: bool = true:
	set(b): can_be_dragged = b
	get: return can_be_dragged

var glowing: bool = false:
	set(b):
		$Glowing.visible = b
		glowing = b
	get: return glowing

var show_shadow: bool = false:
	set(b):
		$Shadow.visible = b
		show_shadow = b
	get: return show_shadow

var scale_factor: float = 1.0:
	set(b):
		self.scale = Vector2(b, b)
		scale_factor = b
	get: return scale_factor

@export var show_icon: bool = false:
	set(b):
		icon.visible = b
		show_icon = b
	get: return show_icon

var _is_waiting_double_click: bool = false:
	set(b):
		if b: $DoubleClickTimer.start()
		else: $DoubleClickTimer.stop()
		_is_waiting_double_click = b
	get: return _is_waiting_double_click

		
### 当鼠标悬停在牌上时的动画
var tweens = {
	"hover": null,
}

func _ready() -> void:
	$DoubleClickTimer.timeout.connect(func():
		_is_waiting_double_click = false
		# print("card_clicked")
		emit_signal("card_clicked", self)
	)
	show_shadow = false
	var timer = $AudioStreamPlayer.get_node("Timer")
	timer.timeout.connect(func():
		$AudioStreamPlayer.stop()
		playing_sound.stop()
		if sounds_queue.size() > 0:
			var sound = sounds_queue.pop_front()
			_play_segment(sound["path"], sound["sound_start"], sound["sound_end"])
		
		)

func stop_play_segments():
	play_segments([ {"path": "", "sound_start": 0, "sound_end": 0, }])


func _play_segment(path: String, start_time: float, end_time: float):
	var player = $AudioStreamPlayer
	player.stop()
	var timer = $AudioStreamPlayer.get_node("Timer")
	var duration = max(0.01, end_time - start_time)
	timer.one_shot = true
	timer.wait_time = duration
	timer.start()
	if path == "": return
	var stream: AudioStream = load(path)
	if stream == null: return
	player.stream = stream
	player.play(start_time) # 从 start_time 秒开始播放
	playing_sound.play()


func play_segments(sounds):
	var sound = sounds.pop_front()
	_play_segment(sound["path"], sound["sound_start"], sound["sound_end"])
	sounds_queue = sounds

func play_dealing_animation(towhere, duration):
	# 一边动一边转
	self.is_playing_animation = true
	self.rotation = deg_to_rad(-70)
	var tween_rotation_move = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	var tween_flap = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	self.material.set_shader_parameter("fov", 16) # 16 测试效果比较好
	tween_rotation_move.parallel().tween_property(self, "rotation", deg_to_rad(0), duration)
	tween_rotation_move.parallel().tween_property(self, "position", towhere, duration)
	tween_flap.tween_property(self.material, "shader_parameter/y_rot", -89, duration / 2)
	tween_flap.tween_callback(func():
		self.flap_to_front(true)
		self.material.set_shader_parameter("y_rot", 89)
	)

	tween_flap.tween_property(self.material, "shader_parameter/y_rot", 0, duration / 2)
	
	await tween_flap.finished
	# 发完成, 归正
	self.material.set_shader_parameter("fov", 90)
	self.is_playing_animation = false

func _fresh_shadow_pos() -> void:
	var ratio = global_position / get_viewport_rect().size * Vector2(1, -1) + Vector2(-0.5, 1)
	$Shadow.position = ratio * Vector2(60, 30)

func _process(_delta: float) -> void:
	if can_be_dragged: _follow_mouse()
	if not is_playing_animation: _self_spin(_delta)
	

func play_pronunciation():
	var info = GlobalDb.words.japanese[self.id]
	GlobalFunction.play_segments([ {
			"path": info["sound_file"],
			"sound_start": info["sound_start"],
			"sound_end": info["sound_end"],
		}])

func play_example_sound():
	var info = GlobalDb.words.japanese[self.id]
	var sounds = []
	for example_id in info["example_id"]:
		var example_info = GlobalDb.words.example[example_id]
		sounds.append({
			"path": example_info["sound_file"],
			"sound_start": example_info["sound_start"],
			"sound_end": example_info["sound_end"],
		})
	GlobalFunction.play_segments(sounds)

func _self_spin(_delta: float):
	if self._is_front:
		life += (_delta / Engine.time_scale * 90)
		var radius = 3.0
		var radians = deg_to_rad(life + self.id)
		var x = radius * cos(radians)
		var y = radius * sin(radians)
		self.material.set_shader_parameter("x_rot", y)
		self.material.set_shader_parameter("y_rot", x)


func _follow_mouse() -> void:
	if self._is_pressed:
		_fresh_shadow_pos()
		global_position = get_global_mouse_position() + self._pos_offset
		emit_signal("card_dragging", self)

func _on_touch_layer_mouse_entered() -> void:
	GlobalFunction.print_log(self.show_log, [self.id, "鼠标入"])
	GlobalFunction.kill_tween(self.tweens.hover)
	tweens.hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tweens.hover.tween_property(self, "scale", Vector2(scale_factor * scale_on_hover, scale_factor * scale_on_hover), 0.5)


func _on_touch_layer_mouse_exited() -> void:
	GlobalFunction.print_log(self.show_log, [self.id, "鼠标出"])
	GlobalFunction.kill_tween(self.tweens.hover)
	tweens.hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR).set_parallel(true)
	tweens.hover.tween_property(self, "scale", Vector2(scale_factor, scale_factor), 0.1)


# gui 的 event.position 是 local 的位置
func _on_touch_layer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			GlobalFunction.print_log(self.show_log, [self.id, "鼠标按下"])
			emit_signal("card_pressed", self)
			self._is_pressed = true
			self.show_shadow = true
			self._pos_offset = global_position - get_global_mouse_position()
			self._pos_pressed = get_global_mouse_position()
			if _is_waiting_double_click:
				_is_waiting_double_click = false
				# print("card_double_clicked")
				emit_signal("card_double_clicked", self)
				self._time_pressed = 0
				return
			self._time_pressed = Time.get_ticks_msec()
		else:
			GlobalFunction.print_log(self.show_log, [self.id, "鼠标松开"])
			self._is_pressed = false
			self.show_shadow = false
			emit_signal("card_release", self)
			self._time_released = Time.get_ticks_msec()
			var delta_time = self._time_released - self._time_pressed
			var delta_pos = get_global_mouse_position().distance_to(self._pos_pressed)
			# print(delta_time," ", delta_pos," ",not _is_waiting_double_click)
			if delta_time < 200 and delta_pos < 50 and not _is_waiting_double_click:
				_is_waiting_double_click = true

func set_collision(b: bool):
	self.collision_area.disabled = not b

func is_dragging() -> bool:
	return self._is_pressed

func get_area_2d() -> Area2D:
	return $Area2D

func get_size():
	return $Front.texture.get_size() * $Front.scale

func is_pressed() -> bool:
	return self._is_pressed

func init(_id: int, show_what: String) -> void:
	self.id = _id
	$Back.texture = load("res://assets/default/back.png")
	self.word.text = GlobalDb.words.japanese[_id][show_what]
	flap_to_front(false)

func get_visible_surface():
	if $Front.visible:
		return $Front
	else:
		return $Back

func flap_to_front(front_or_back: bool):
	$Front.visible = front_or_back
	$Back.visible = not front_or_back
	self._is_front = front_or_back

######## public methods ########
func set_card_text(new_text: String):
	word.text = new_text
