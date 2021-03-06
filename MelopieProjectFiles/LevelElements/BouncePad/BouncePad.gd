extends Area2D


export var bounce_strength: float
export var bounce_direction: Vector2

func _ready():
	connect("body_entered", self, "on_body_entered")
	
func on_body_entered(body: Node2D):
	if body.has_method("bounce"):
		body.bounce(bounce_strength * bounce_direction)
		

