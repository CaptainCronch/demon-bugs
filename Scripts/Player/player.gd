extends CharacterBody3D
class_name Player

var jump_move_multiplier := 1.5
var jump_force := 12.0
var throw_force := 5.0

var base_gravity := 50.0
var fall_gravity := 60.0
var peak_gravity := 30.0
var peak_range := 3.0
var max_fall_speed := -100.0
var buffer_time := 0.2
var coyote_time := 0.2

var base_acceleration := 10.0
var base_friction := 30.0
var air_acceleration := 3.0
var air_friction := 1.0

var turn_acceleration := 120.0
var multiplier_decay := 3.0
var stun_time := 0.5

var move_dir := Vector2.ZERO
var stunned := false
var explosive_jumping := false
var holding_item := false
var move_speed : float
var move_multiplier := 1.0
var _gravity := base_gravity
var _acceleration := base_acceleration
var _friction := base_friction
var _desired_velocity := Vector2()

@export var model : VisualInstance3D
@export var item_holder : Node3D
@export var spring_arm : SpringArm3D
@export var buffer_timer : Timer
@export var coyote_timer : Timer
@export var animation_player : AnimationPlayer
@export var pickup_area : Area3D


func _ready() -> void :
	if item_holder.get_child(0):
		holding_item = true


func _process(_delta : float) -> void :
	get_input()
	#$StateDebug.text = str(roundf(Vector2(velocity.x, velocity.z).length()))
	#$StateDebug.text = str(_acceleration)
	
	if not stunned:
		model_controls(_delta)


func _physics_process(_delta : float) -> void :
	_desired_velocity = move_dir * move_speed * move_multiplier
	air_movement(_delta)
	ground_movement(_delta)
	
	move_and_slide()



func _unhandled_input(event : InputEvent) -> void :
	if event.is_action_pressed("jump"):
		buffer_timer.start(buffer_time) # waits until you touch the ground to jump
	elif event.is_action_pressed("interact"):
		pick_up()


func get_input() -> void :
	move_dir = Vector2.ZERO
	
	move_dir.x = Input.get_axis("left", "right")
	move_dir.y = Input.get_axis("forward", "back")
	move_dir = move_dir.rotated(-spring_arm.rotation.y).limit_length()


func air_movement(delta : float) -> void :
	if velocity.y >= peak_range: _gravity = base_gravity
	elif velocity.y <= -peak_range: _gravity = fall_gravity
	else: _gravity = peak_gravity # dfferent gravities applied based on y velocity
	
	velocity.y -= _gravity * delta # gravity
	velocity.y = maxf(velocity.y, max_fall_speed) # max fall speed
	
	if is_on_floor():
		coyote_timer.start(coyote_time) # starts letting you jump
	
	if not coyote_timer.is_stopped() and not buffer_timer.is_stopped():
		velocity.y = jump_force
		move_multiplier = jump_move_multiplier
		velocity.x *= jump_move_multiplier
		velocity.z *= jump_move_multiplier
		
		buffer_timer.stop()
		coyote_timer.stop()
	
	if not Input.is_action_pressed("jump"):
		if velocity.y > jump_force * 0.5 and velocity.y <= jump_force * 1 and not explosive_jumping:
			velocity.y = jump_force * 0.5 # jump cut when you let go of jump
			
			move_multiplier = 1.0 # also resets speed boost to discourage spamming
			var cut_velocity := move_dir * move_speed
			if Vector2(velocity.x, velocity.z).length_squared() > cut_velocity.length_squared():
				velocity.x = cut_velocity.x
				velocity.z = cut_velocity.y

func ground_movement(delta : float) -> void :
	if is_on_floor():
		_acceleration = base_acceleration
		_friction = base_friction
		move_multiplier = Global.decay_towards(move_multiplier, 1.0, multiplier_decay, true)
		explosive_jumping = false
	else:
		_acceleration = air_acceleration
		_friction = air_friction
	
	if move_dir != Vector2.ZERO and not stunned:
		velocity.x = Global.decay_towards(velocity.x, _desired_velocity.x, _acceleration, delta)
		velocity.z = Global.decay_towards(velocity.z, _desired_velocity.y, _acceleration, delta)
	else:
		velocity.x = Global.decay_towards(velocity.x, 0.0, _friction, delta)
		velocity.z = Global.decay_towards(velocity.z, 0.0, _friction, delta)


func model_controls(delta : float) -> void :
	if move_dir != Vector2.ZERO:
		
		model.rotation.y = Global.decay_angle_towards(
				model.rotation.y, atan2(move_dir.x, move_dir.y) + PI,
				turn_acceleration * 0.1, delta)


func use_tool() -> void :
	stun(true)
	await get_tree().create_timer(stun_time).timeout
	stun(false)


func throw_item(power_level) -> void :
	var item : Item = item_holder.get_child(0) as Item
	item_holder.remove_child(item)
	get_tree().current_scene.add_child(item)
	item.global_position = item_holder.global_position
	item.rotation.y = model.rotation.y
	item.freeze = false
	holding_item = false
	var offset := randf_range(-1.0, 1.0)
	item.linear_velocity = (Vector3(0, 0.5, -1).rotated(Vector3.UP, model.rotation.y) * throw_force * power_level) + (velocity * 0.5)
	item.angular_velocity = Vector3(offset, offset, offset) * throw_force


func stun(on : bool) -> void :
	stunned = on
	move_dir = Vector2.ZERO


func explode(origin : Vector3, radius : float, power : float, upthrust := 0.0) -> void :
	var distance_factor := (inverse_lerp(0, radius, global_position.distance_to(origin)) * -0.5) + 1
	if distance_factor < 0.5: return
	
	var up_pos := Vector3(global_position.x, global_position.y + upthrust, global_position.z)
	velocity += origin.direction_to(up_pos) * distance_factor * power
	explosive_jumping = true


func pick_up():
	if not holding_item and pickup_area.has_overlapping_bodies():
		var body := pickup_area.get_overlapping_bodies()[0]
		if body is Item:
			body.get_parent().remove_child(body)
			item_holder.add_child(body)
			body.global_position = item_holder.global_position
			body.rotation = item_holder.rotation
			body.freeze = true
			holding_item = true


func _on_net_area_entered(area : Area3D) -> void :
	pass # Replace with function body.
