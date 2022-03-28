extends Node2D

func _ready():
	pass # Replace with function body.

func respawn():
	Global.player.position.x=Global.checkpoint.x
	Global.player.position.y=Global.checkpoint.y
	Global.player.flapped = false
	Global.player.velocity = Vector2.ZERO
