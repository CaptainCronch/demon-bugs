extends Area3D
class_name HurtAreaComponent

@export var attack : Attack
@export var detection_groups : PackedStringArray = ["player"]

@onready var collider : CollisionShape3D = $CollisionShape3D


func _physics_process(_delta):
	if not monitoring: return
	for area in get_overlapping_areas():
		if area is HitboxComponent:
			for group in detection_groups:
				if area.is_in_group(group):
					attack.attack_position = global_position
					area.damage(attack)
					break
