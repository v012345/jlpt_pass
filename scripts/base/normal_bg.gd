extends Control

@export var show_vhs: bool = false

# 红色用的

@export var colour_1: Color = Color(0.871, 0.267, 0.231, 1.0)
@export var colour_2: Color = Color(0.0, 0.42, 0.706, 1.0)
@export var colour_3: Color = Color(0.086, 0.137, 0.145, 1.0)
@export var polar_repeat: float = 3.0
@export var spin_rotation: float = 2.0
@export var spin_speed: float = 7.0
@export var contrast: float = 3.5
@export var lighting: float = 0.2
@export var spin_amount: float = 0.2
@export var pixel_filter: float = 740


# 绿色用的
# @export var colour_1: Color = Color(0.216, 0.49, 0.357, 1.0)
# @export var colour_2: Color = Color(0.227, 0.416, 0.337, 1.0)
# @export var colour_3: Color = Color(0, 0, 0, 0.0)
# @export var polar_repeat: float = 3.0
# @export var spin_rotation: float = 1.0
# @export var spin_speed: float = 6.0
# @export var contrast: float = 1.5
# @export var lighting: float = 0.0
# @export var spin_amount: float = 0.1
# @export var pixel_filter: float = 800

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Swirl.visible = true
	$Swirl.material.set_shader_parameter("colour_1", colour_1)
	$Swirl.material.set_shader_parameter("colour_2", colour_2)
	$Swirl.material.set_shader_parameter("colour_3", colour_3)
	$Swirl.material.set_shader_parameter("polar_repeat", polar_repeat)
	$Swirl.material.set_shader_parameter("spin_rotation", spin_rotation)
	$Swirl.material.set_shader_parameter("spin_speed", spin_speed)
	$Swirl.material.set_shader_parameter("contrast", contrast)
	$Swirl.material.set_shader_parameter("lighting", lighting)
	$Swirl.material.set_shader_parameter("spin_amount", spin_amount)
	$Swirl.material.set_shader_parameter("pixel_filter", pixel_filter)
	$Vhs.visible = show_vhs
