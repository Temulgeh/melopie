extends Control

var is_paused := false


func set_paused(value: bool):
	is_paused = value
	get_tree().paused = is_paused

func _input(event):
	if event.is_action_pressed("pause"):
		is_paused = not is_paused
		set_paused(is_paused)
