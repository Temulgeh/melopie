extends KinematicBody2D
class_name MovableBlock

export var GRAVITY: float

var velocity: Vector2


func _ready():
	pass


func _physics_process(delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)	
	velocity=Vector2.ZERO

func slide(vector):
	velocity.x=vector.x

