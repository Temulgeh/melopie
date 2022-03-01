extends Area2D


export var wind_strength: float
export var wind_direction: Vector2
export var acceleration: float

var colliding_bodies: Dictionary


func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	wind_direction = wind_direction.normalized()


func on_body_entered(body: Node2D):
	colliding_bodies[body.get_instance_id()] = body


func on_body_exited(body: Node2D):
	colliding_bodies.erase(body.get_instance_id())


func _physics_process(delta):
	for body in colliding_bodies.values():
		if "velocity" in body:
			var velocity_dot: float = body.velocity.dot(wind_direction)
			var velocity_normal: Vector2 = body.velocity.project(Vector2(-wind_direction.y, wind_direction.x))
			velocity_dot = lerp(velocity_dot, wind_strength, acceleration)
			body.velocity = wind_direction * velocity_dot + velocity_normal
	
