extends Node3D
class_name MeleeComponent

signal hit()

@export var parent : Node3D
@export var base_shape : Shape3D
@export var base_attack : Attack
@export_flags_3d_physics var layers : int


func melee(shape := base_shape, attack := base_attack) -> void : ## Call only from _physics_process.
	var world := get_world_3d().direct_space_state
	var params := PhysicsShapeQueryParameters3D.new()
	params.collide_with_areas = true
	params.collide_with_bodies = false
	params.margin = 0.4
	params.shape = shape
	params.collision_mask = layers
	params.transform = global_transform
	var collisions := world.intersect_shape(params)

	var pos_attack := attack
	attack.attack_position = parent.global_position

	for collision in collisions:
		if collision.collider is HitboxComponent:
			collision.collider.damage(pos_attack)
