# LE FICHIER N'EST PAS AUX NORMES (sera corrigé plus tard tm) NE VOUS EN INSPIREZ PAS

extends KinematicBody2D


const MOVEMENT_AMOUNT: float = 0.05
const GLIDING_BASE_OFFSET: Vector2 = Vector2(10.0, 10.0)
const GLIDING_VEL_OFFSET: float = 10.0
const WALKING_ZOOM_IN: float = 1.0
const WALKING_ZOOM_OUT: float = 1.0
const GLIDING_ZOOM_IN: float = 1.02
const GLIDING_ZOOM_OUT: float = 2.0
const ZOOM_BOUNDS_SPEED: float = 0.06
const ZOOM_SPEED: float = 0.04
const ZOOM_BASE: float = 1.1

export var player_node: NodePath

onready var player: KinematicBody2D = get_node(player_node)
onready var camera: Camera2D = $Camera2D

var zoom: float = WALKING_ZOOM_IN
var zoom_in: float = WALKING_ZOOM_IN
var zoom_out: float = WALKING_ZOOM_OUT


func _physics_process(delta):
	var target_position = player.global_position
	var zoom_target: float
	if player.gliding:
		var flipped_offset: Vector2 = GLIDING_BASE_OFFSET
		flipped_offset.x *= player.facing
		target_position += player.velocity * GLIDING_VEL_OFFSET + flipped_offset
		
		zoom_in = lerp(zoom_in, GLIDING_ZOOM_IN, ZOOM_BOUNDS_SPEED)
		zoom_out = lerp(zoom_out, GLIDING_ZOOM_OUT, ZOOM_BOUNDS_SPEED)
	else:
		zoom_in = lerp(zoom_in, WALKING_ZOOM_IN, ZOOM_BOUNDS_SPEED)
		zoom_out = lerp(zoom_out, WALKING_ZOOM_OUT, ZOOM_BOUNDS_SPEED)
	var zoom_amount = 1.0 - pow(ZOOM_BASE, -player.velocity.length())
	zoom_target = lerp(zoom_in, zoom_out, zoom_amount * zoom_amount)
	zoom = lerp(zoom, zoom_target, ZOOM_SPEED)
	camera.zoom = Vector2(zoom, zoom)
	var difference: Vector2 = target_position - global_position
	move_and_slide(difference * MOVEMENT_AMOUNT / delta)
