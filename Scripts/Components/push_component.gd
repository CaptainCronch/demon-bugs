extends Node3D
class_name PushComponent

@export var push_force : float
@export var target : CharacterBody3D

func _physics_process(_delta):
	for i in target.get_slide_collision_count():
		var col = target.get_slide_collision(i)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_force(col.get_normal() * -push_force)
