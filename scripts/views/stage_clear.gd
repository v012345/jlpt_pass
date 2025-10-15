extends ViewBase
var tween_logo: Tween
var tween_page: Tween

signal play_again()
signal to_exam()

func _ready() -> void:
	super._ready()

func _on_button_restart_pressed() -> void:
	emit_signal("play_again")
	self.queue_free()


func _on_button_back_pressed() -> void:
	emit_signal("to_exam")
	self.queue_free()
