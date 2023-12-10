extends CharacterBody3D
class_name Player

var jump_move_multiplier := 1.2
var throw_force := 5.0

var buffer_time := 0.2
var coyote_time := 0.2

var tool_stun_time := 0.5

var holding_item := false
var held_item : Item

@export var model : VisualInstance3D
@export var item_holder : Node3D
@export var spring_arm : SpringArm3D
@export var buffer_timer : Timer
@export var coyote_timer : Timer
@export var animation_player : AnimationPlayer
@export var pickup_area : Area3D
@export var health_bar : TextureProgressBar
@export var plat_comp : PlatformerComponent
@export var health_comp : HealthComponent


func _ready() -> void :
	health_bar.max_value = health_comp.max_health
	health_bar.value = health_comp.health
	health_comp.damage_taken.connect(update_health_bar)
	if item_holder.get_child(0):
		holding_item = true
		held_item = item_holder.get_child(0)
		held_item.global_position = item_holder.global_position
		for child in held_item.get_children():
				if child is CollisionShape3D:
					child.disabled = true


func _process(_delta : float) -> void :
	get_input()


func _physics_process(_delta : float) -> void :
	air_movement(_delta)


func _input(event : InputEvent) -> void :
	if event.is_action_pressed("jump"):
		buffer_timer.start(buffer_time) # waits until you touch the ground to jump


func get_input() -> void :
	plat_comp.move_dir = Vector2.ZERO

	plat_comp.move_dir.x = Input.get_axis("left", "right")
	plat_comp.move_dir.y = Input.get_axis("forward", "back")
	plat_comp.move_dir = plat_comp.move_dir.rotated(-spring_arm.rotation.y).limit_length()


func air_movement(_delta : float) -> void :
	if is_on_floor():
		coyote_timer.start(coyote_time) # starts letting you jump

	if not coyote_timer.is_stopped() and not buffer_timer.is_stopped():
		plat_comp.jump()
		plat_comp.move_multiplier = jump_move_multiplier
		velocity.x *= jump_move_multiplier
		velocity.z *= jump_move_multiplier

		buffer_timer.stop()
		coyote_timer.stop()

	#if not Input.is_action_pressed("jump"):
		#if plat_comp.explosive_jumping: return
		#if velocity.y > plat_comp.jump_force * 0.5 and velocity.y <= plat_comp.jump_force * 1:
			#velocity.y = plat_comp.jump_force * 0.5 # jump cut when you let go of jump
			#
			#plat_comp.move_multiplier = 1.0 # resets speed boost to discourage spamming
			#var cut_velocity := plat_comp.move_dir * plat_comp.move_speed
			#if Vector2(velocity.x, velocity.z).length_squared() > cut_velocity.length_squared():
				#velocity.x = cut_velocity.x # removes multiplier from move speed
				#velocity.z = cut_velocity.y


func throw_item(power_level) -> void :
	var item : Item = item_holder.get_child(0) as Item
	if not item: return

	for child in item.get_children():
		if child is CollisionShape3D:
			child.disabled = false

	item_holder.remove_child(item)
	get_tree().current_scene.add_child(item)

	item.global_position = item_holder.global_position
	item.rotation.y = model.rotation.y
	item.freeze = false
	holding_item = false
	held_item = null
	var offset := randf_range(-1.0, 1.0)
	item.linear_velocity = (Vector3(0, 0.5, -1).rotated(Vector3.UP, model.rotation.y) * throw_force * power_level) + (velocity * 0.5)
	item.angular_velocity = Vector3(offset, offset, offset) * throw_force


func stun(time : float) -> void :
	plat_comp.stun(time)


func explode(origin : Vector3, radius : float, power : float, upthrust := 0.0) -> void :
	plat_comp.explode(origin, radius, power, upthrust)


func update_health_bar(_attack : Attack):
	health_bar.value = health_comp.health
