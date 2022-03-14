extends Area2D


export var next_level: String


func _ready():
	connect("body_entered", self, "on_body_entered")


func on_body_entered(body: Node2D):
	LevelChange.level_change(next_level)

