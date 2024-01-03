extends Node3D
class_name MeleeComponent

signal hit(hitbox : HitboxComponent)

@export var parent : Node3D
@export var shape : BoxShape3D ## By default a BoxShape3D with Vector3(3, 2, 1). Desired forward range on Z + 1.
@export_flags_3d_physics var layers : int

var params : PhysicsShapeQueryParameters3D


func _ready():
	params = PhysicsShapeQueryParameters3D.new()
	params.collide_with_areas = true
	params.collide_with_bodies = false
	params.margin = 0.4
	params.collision_mask = layers


func melee(attack : Attack, pos : Vector3, rot : Vector3, offset := true) -> void : ## Call only from _physics_process.
	var world := get_world_3d().direct_space_state

	params.shape = shape
	var pos_offset := Vector3.FORWARD.rotated(Vector3.UP, rot.y) * ((shape.size.z / 2) - 0.5) if offset else Vector3()
	pos_offset += Vector3.UP * ((shape.size.y / 2) - 1) if offset else Vector3() # add forwards and up offsets so melee hit comes from the front and above
	params.transform = Transform3D(Basis.from_euler(rot), pos + pos_offset)
	var collisions := world.intersect_shape(params, 128)

	for collision in collisions:
		if collision.collider is HitboxComponent:
			collision.collider.damage(attack)
			hit.emit(collision.collider)
