# LE FICHIER N'EST PAS AUX NORMES (sera corrigé plus tard tm) NE VOUS EN INSPIREZ PAS
# lol pas corrigé

extends KinematicBody2D


# TODO fix everything (movement is borked)
# TODO bump on wall if speed is high enough, tiny delay before you can glide again

const PIE: float = PI

const c_running_speed: float = 1.9
const c_ground_half_speed_time: float = 3.0
const c_air_half_speed_time: float = 7.0
const c_ground_friction: float = 1.0 - pow(0.5, 1.0 / c_ground_half_speed_time)
const c_air_friction: float = 1.0 - pow(0.5, 1.0 / c_air_half_speed_time)

const c_jump_buffer_time: int = 5
const c_coyote_time: int = 6

const c_high_jump_time: int = 8
const c_jump_force: float = -3.0
const c_gravity: float = 0.3
const c_high_jump_gravity: float = 0.1
const c_jump_apex_velocity: float = 0.5
const c_jump_apex_gravity: float = c_gravity * 0.5
const c_jump_boost: float = 1.05
const c_max_gravity: float = 4.7

const c_flap_force: float = -3.0
const c_flap_boost: float = 1.0
const c_flap_leftover_speed: float = 0.4

const c_gliding_rot_amount: float = 0.1
const c_gliding_manual_rot_change: float = 0.5
const c_gliding_param_slide_amount: float = 0.2
const c_gliding_gravity: float = 0.15
const c_gliding_min_lift_coeff: float = 0.0
const c_gliding_mid_lift_coeff: float = 0.01
const c_gliding_max_lift_coeff: float = 0.03
const c_gliding_min_drag_coeff: float = 0.0004
const c_gliding_mid_drag_coeff: float = 0.002
const c_gliding_max_drag_coeff: float = 0.0038
const c_gliding_nosedive: float = 0.04
# dirty fix :>
const c_gliding_anti_loop_of_loop: float = 0.05
const c_gliding_lift_direction_power: float = 2.5

const c_no_flying_allowed_time: int = 30

const c_anim_rotation_speed: float = 0.3
const c_anim_glide_less_rotation_time: int = 30
const c_anim_run_threshold: float = 0.1
const c_anim_run_min_speed: float = 0.6
const c_anim_run_max_speed: float = 1.4
const c_anim_keep_running_every_second_you_are_not_running_they_are_getting_closer: int = 3

onready var sprite := $Sprite
onready var animation_player := $AnimationPlayer

var input_direction: float
var velocity: Vector2
var gliding_angle: float
var gliding_speed: float

var jump_buffer_timer: int
var coyote_timer: int
var jump_timer: int
var anim_glide_less_rotation_timer: int
var jumping: bool
var flapped: bool
var gliding: bool
var facing: int = 1
var gliding_lift_coeff: float
var gliding_drag_coeff: float
var no_flying_allowed_uwu: int

var animations_locked: bool = false
var frozen: bool = false
var oh_god_oh_no_they_are_coming: int = 0


func _ready():
	Global.player = self


func _input(event):
	if event.is_action_pressed("left"):
		input_direction = -1.0
	elif event.is_action_pressed("right"):
		input_direction = 1.0
	elif event.is_action_released("left") or event.is_action_released("right"):
		input_direction = (
			  int(Input.is_action_pressed("right"))
			- int(Input.is_action_pressed("left"))
		)
	elif event.is_action_pressed("jump"):
		jump_buffer_timer = c_jump_buffer_time


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		input_direction = 0.0


func _physics_process(delta):
	if not frozen:
		movement_and_controls_and_all_that_kind_of_stuff(delta)


func jump():
	velocity.y = c_jump_force
	velocity.x *= c_jump_boost
	jump_timer = 0
	jumping = true
	animation_player.play("RESET")
	animation_player.queue("Jump")


func flap():
	flapped = true
	velocity.y = c_flap_force
	velocity.x = c_flap_boost * facing + velocity.x * c_flap_leftover_speed
	gliding_speed = velocity.length()
	if facing == 1:
		gliding_angle = velocity.angle()
	else:
		gliding_angle = -velocity.angle() + PIE
	gliding_angle = fmod(gliding_angle + PIE / 2, PIE) - PIE / 2
	animation_player.play("RESET")
	animation_player.play("Flap")
	anim_glide_less_rotation_timer = c_anim_glide_less_rotation_time


func glide():
	gliding = true
	velocity.x *= facing # FLIP
	var velocity_angle = velocity.angle()
	var adapted_input = input_direction * facing
	gliding_angle = lerp_angle(
		gliding_angle,
		velocity_angle + adapted_input * c_gliding_manual_rot_change,
		c_gliding_rot_amount
	)
	gliding_angle += c_gliding_nosedive
	velocity.y += c_gliding_gravity
	var target_lift_coeff: float
	var target_drag_coeff: float
	if adapted_input == 1:
		target_lift_coeff = c_gliding_min_lift_coeff
		target_drag_coeff = c_gliding_min_drag_coeff
	elif adapted_input == -1:
		target_lift_coeff = c_gliding_max_lift_coeff
		target_drag_coeff = c_gliding_max_drag_coeff
	else:
		target_lift_coeff = c_gliding_mid_lift_coeff
		target_drag_coeff = c_gliding_mid_drag_coeff
	gliding_lift_coeff = lerp(gliding_lift_coeff, target_lift_coeff, c_gliding_param_slide_amount)
	gliding_drag_coeff = lerp(gliding_drag_coeff, target_drag_coeff, c_gliding_param_slide_amount)
	var speed_squared = velocity.length() * velocity.length()
	var speed_cubed = speed_squared * velocity.length()
	var lift: Vector2 = Vector2.UP.rotated(gliding_angle) * speed_squared * gliding_lift_coeff
	var compl_lift_right_direction_ness: float = 1.0 - (Vector2.UP.dot(lift) + 1.0) / 2.0
	lift *= 1.0 - pow(compl_lift_right_direction_ness, c_gliding_lift_direction_power)
	velocity += lift
	velocity += -velocity.normalized() * speed_cubed * gliding_drag_coeff
	if velocity.x < 0.0:
		velocity.x *= 1.0 - c_gliding_anti_loop_of_loop
	velocity.x *= facing # UNFLIP


func peck():
	pass


func bounce(force: Vector2):
	no_flying_allowed_uwu = c_no_flying_allowed_time
	flapped = false
	var force_direction: Vector2 = force.normalized()
	velocity -= force_direction.dot(velocity) * force_direction
	velocity += force


func movement_and_controls_and_all_that_kind_of_stuff(delta: float):
	if flapped and Input.is_action_pressed("jump"):
		if not no_flying_allowed_uwu:
			if Input.is_action_just_pressed("jump") and input_direction != 0:
				facing = sign(input_direction)
			glide()
	else:
		gliding = false
		var friction: float = c_ground_friction if is_on_floor() else c_air_friction
		velocity.x = lerp(velocity.x, c_running_speed * input_direction, friction)
		var gravity: float = c_gravity
		jumping = jumping and Input.is_action_pressed("jump")
		if jumping:
			if jump_timer < c_high_jump_time:
				gravity = c_high_jump_gravity
			elif abs(velocity.y) < c_jump_apex_velocity:
				gravity = c_jump_apex_gravity
		if velocity.y < c_max_gravity:
			velocity.y = min(c_max_gravity, velocity.y + gravity)
		
		if jump_buffer_timer and coyote_timer:
			jump()
		elif jump_buffer_timer and not flapped and not is_on_floor():
			flap()
# Input buffering (it doesn't work for now)
#			if velocity.y > 0:
#				var collision: KinematicCollision2D = move_and_collide(jump_buffer_timer * velocity, true, true, true)
#				if not collision:
#					flap()
#				elif collision.normal.dot(Vector2.UP) < 0:
#					var actual_position: Vector2 = position
#					position += collision.travel
#					if not move_and_collide(Vector2(
#						0.0, jump_buffer_timer * velocity.y - collision.travel.y
#					), true, true, true):
#						flap()
#			else:
#				flap()
	
	tick_timers()
	
	move_and_slide(velocity / delta, Vector2.UP)
	for index in get_slide_count():
		var collision=get_slide_collision(index)
		if collision.collider is MovableBlock:
			collision.collider.slide(-collision.normal*(c_running_speed*40))
	if is_on_floor():
		velocity.y = 0.0
		coyote_timer = c_coyote_time
		flapped = false
	if is_on_ceiling():
		velocity.y = 0.0
	if is_on_wall():
		velocity.x = 0.0
	
	animate()


func tick_timers():
	if coyote_timer > 0:
		coyote_timer -= 1
	if jump_buffer_timer > 0:
		jump_buffer_timer -= 1
	if jumping:
		jump_timer += 1
	if anim_glide_less_rotation_timer > 0:
		anim_glide_less_rotation_timer -= 1
	if no_flying_allowed_uwu > 0:
		no_flying_allowed_uwu -= 1


func animate():
	var target_angle: float = gliding_angle * pow(
		1.0 - float(anim_glide_less_rotation_timer) / c_anim_glide_less_rotation_time,
		2.0
	)
	if gliding:
		target_angle *= facing
		if not animations_locked:
			glide_animation()
	else:
		target_angle = 0
		if velocity.x:
			facing = sign(velocity.x)
		sprite.scale.x = facing
		if not animations_locked:
			if is_on_floor():
				if abs(velocity.x) > c_anim_run_threshold:
					oh_god_oh_no_they_are_coming = c_anim_keep_running_every_second_you_are_not_running_they_are_getting_closer
					animation_player.play("Run")
					animation_player.playback_speed = lerp(
						c_anim_run_min_speed,
						c_anim_run_max_speed,
						(abs(velocity.x) - c_anim_run_threshold) /
						(c_running_speed - c_anim_run_threshold)
					)
				elif oh_god_oh_no_they_are_coming > 0:
					oh_god_oh_no_they_are_coming -= 1
					# very wet code
					animation_player.play("Run")
					animation_player.playback_speed = lerp(
						c_anim_run_min_speed,
						c_anim_run_max_speed,
						(abs(velocity.x) - c_anim_run_threshold) /
						(c_running_speed - c_anim_run_threshold)
					)
				else:
					animation_player.play("RESET")
					animation_player.queue("Idle")
			else:
				# TERRIBLE HACK THAT DEFEATS THE POINT OF SOME OTHER STUFF I DID
				if not (animation_player.current_animation in ["RESET", "Jump", "Flap"] or animations_locked):
					animation_player.play("Jump")
					animation_player.seek(0.3)
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, c_anim_rotation_speed)


func lock_animations():
	animations_locked = true


func unlock_animations():
	animations_locked = false


func freeze():
	frozen = true


func unfreeze():
	frozen = false


func glide_animation():
	if not animations_locked:
#		animation_player.play("RESET")
		animation_player.play("Glide")


func reset_playback_speed():
	animation_player.playback_speed = 1.0
