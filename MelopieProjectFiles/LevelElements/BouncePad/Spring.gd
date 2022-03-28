extends Node2D


onready var animation_player := $AnimationPlayer


func _ready():
	$Area2D.connect("body_entered", self, "boingboing")


func boingboing(_body):
	animation_player.play("boing")
	animation_player.seek(0.0)

