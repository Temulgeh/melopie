extends Node2D



func level_change(next_level: String):
	get_tree().change_scene(next_level)
