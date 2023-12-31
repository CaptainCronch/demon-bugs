extends Node
class_name PlatformerComponent

@export var jump_force := 8.0
@export var max_fall_speed := -100.0

@export var base_gravity := 20.0
@export var fall_gravity := 30.0
@export var peak_gravity := 20.0
@export var peak_range := 3.0

@export var move_speed := 4.0

@export var base_acceleration := 10.0
@export var base_friction := 30.0
@export var air_acceleration := 3.0
@export var air_friction := 1.0
@export var multiplier_decay := 3.0
@export var turn_acceleration := 30.0
@export var knockback_resistance := 0.0
@export var stun_resistance := 0.0

var move_dir := Vector2.ZERO
var gravity := base_gravity
var acceleration := base_acceleration
var friction := base_friction
var move_multiplier := 1.0
var explosive_jumping := false
var stunned := false
var turning := true
var turn_target := Vector2()

@export var target : CharacterBody3D
@export var model : VisualInstance3D
@export var health_comp : HealthComponent

@onready var stun_timer : Timer = $StunTimer


func _ready():
	if health_comp:
		health_comp.damage_taken.connect(knockback)


func _process(_delta) -> void :
	model_controls(move_dir if turn_target == Vector2() else turn_target)


func _physics_process(_delta) -> void :
	air_movement(_delta)
	ground_movement(_delta)
	target.move_and_slide()


func air_movement(delta) -> void :
	if is_on_floor(): return
	if target.velocity.y >= peak_range: gravity = base_gravity
	elif target.velocity.y <= -peak_range: gravity = fall_gravity
	else: gravity = peak_gravity # dfferent gravities applied based on y velocity

	target.velocity.y -= gravity * delta # gravity
	target.velocity.y = max(target.velocity.y, max_fall_speed) # max fall speed


func ground_movement(delta : float) -> void :
	var desired_velocity := move_dir * move_speed * move_multiplier

	if is_on_floor():
		acceleration = base_acceleration
		friction = base_friction
		explosive_jumping = false
		move_multiplier = Global.decay_towards(move_multiplier, 1.0, multiplier_decay, delta)
	else:
		acceleration = air_acceleration
		friction = air_friction

	if move_dir != Vector2.ZERO and not stunned:
		target.velocity.x = Global.decay_towards(target.velocity.x, desired_velocity.x, acceleration, delta)
		target.velocity.z = Global.decay_towards(target.velocity.z, desired_velocity.y, acceleration, delta)
	else:
		target.velocity.x = Global.decay_towards(target.velocity.x, 0.0, friction, delta)
		target.velocity.z = Global.decay_towards(target.velocity.z, 0.0, friction, delta)


func model_controls(dir := move_dir) -> void :
	if dir != Vector2.ZERO and turning and not stunned:
		model.rotation.y = Global.decay_angle_towards(
				model.rotation.y,
				atan2(dir.x, dir.y) + PI,
				turn_acceleration,
				get_process_delta_time())


func jump() -> void :
	if stunned or not is_on_floor(): return
	target.velocity.y = jump_force


func explode(origin : Vector3, radius : float, power : float, upthrust := 0.0) -> void :
	var distance_factor : float = (inverse_lerp(0, radius, target.global_position.distance_to(origin)) * -0.5) + 1
	if distance_factor < 0.5: return

	var upthrust_corrected_position = Vector3(
			target.global_position.x,
			target.global_position.y + upthrust,
			target.global_position.z)

	target.velocity += origin.direction_to(upthrust_corrected_position) * distance_factor * power
	explosive_jumping = true


func knockback(attack : Attack) -> void :
	stun(attack.stun_time)
	if is_zero_approx(attack.knockback_force): return
	var pos_2d := Vector2(target.global_position.x, target.global_position.z)
	var attack_2d := Vector2(attack.attack_position.x, attack.attack_position.z)
	var dir := attack_2d.direction_to(pos_2d)
	var kb_factor := attack.knockback_force - (attack.knockback_force * knockback_resistance)
	var knockback_total := Vector3(dir.x, 1, dir.y).normalized() * kb_factor
	target.velocity = knockback_total


func stun(time : float) -> void :
	if is_zero_approx(time): return
	stunned = true
	#move_dir = Vector2.ZERO
	stun_timer.start(time)


func instant_velocity(direction : Vector2) -> void :
	direction *= move_speed
	target.velocity.x = direction.x
	target.velocity.z = direction.y


func is_on_floor() -> bool :
	return target.is_on_floor()


func _on_stun_timer_timeout():
	stunned = false
