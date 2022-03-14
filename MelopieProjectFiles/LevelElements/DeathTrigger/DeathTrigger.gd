extends Area2D



# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "on_body_entered")


func on_body_entered(body: Node2D):
	
