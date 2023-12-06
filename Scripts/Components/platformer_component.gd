extends Node3D
class_name PlatformerComponent

@export var jump_force : float
@export var max_fall_speed : float
@export var move_speed : float
@export var turn_acceleration : float
@export var gravity : float
@export var acceleration : float
@export var friction : float

var move_dir := Vector2.ZERO
var move_multiplier := 1.0
var explosive_jumping := false
var stunned := false

@export var target : CharacterBody3D
@export var model : VisualInstance3D


func _physics_process(_delta):
	air_movement(_delta)
	ground_movement(_delta)
	target.move_and_slide()
	
	model_controls()


func air_movement(delta) -> void :
	target.velocity.y -= gravity * delta # gravity
	target.velocity.y = max(target.velocity.y, max_fall_speed) # max fall speed


func ground_movement(delta) -> void :
	var desired_velocity = move_dir * move_speed * move_multiplier
	
	if target.is_on_floor():
		explosive_jumping = false
	
	if move_dir != Vector2.ZERO and not stunned:
		target.velocity.x = Global.decay_towards(target.velocity.x, desired_velocity.x, acceleration, true)
		target.velocity.z = Global.decay_towards(target.velocity.z, desired_velocity.y, acceleration, true)
	else:
		target.velocity.x = Global.decay_towards(target.velocity.x, 0.0, friction, true)
		target.velocity.z = Global.decay_towards(target.velocity.z, 0.0, friction, true)


func model_controls() -> void :
	if move_dir != Vector2.ZERO:
		model.rotation.y = Global.decay_angle_towards(model.rotation.y, atan2(move_dir.x, move_dir.y) + PI, turn_acceleration)


func jump():
	target.velocity.y = jump_force


func explode(origin : Vector3, radius : float, power : float, upthrust := 0.0) -> void :
	var distance_factor = (inverse_lerp(0, radius, global_position.distance_to(origin)) * -0.5) + 1
	if distance_factor < 0.5: return
	
	var upthrust_corrected_position = Vector3(
			target.global_position.x,
			target.global_position.y + upthrust,
			target.global_position.z)
	
	target.velocity += origin.direction_to(upthrust_corrected_position) * distance_factor * power
	explosive_jumping = true
