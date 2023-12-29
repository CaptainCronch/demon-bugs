extends Area3D
class_name HurtAreaComponent

signal hit(hitbox : HitboxComponent)

@export var attack : Attack
@export var detection_groups : PackedStringArray
@export var flash_speed := 0.1

var flash_timer := 0.0

@onready var collider : CollisionShape3D = $CollisionShape3D


func _ready():
	if detection_groups[0].is_empty():
		push_error("HitboxComponent of ", str(self), " has no detection groups!")


func _physics_process(delta):
	if flash_speed > 0.0: # if has flash speed and time out then check collisions and restart timer
		flash_timer += delta
		if flash_timer >= flash_speed:
			flash_timer = 0.0
		else: return
	if not monitoring: return
	for area in get_overlapping_areas():
		if area is HitboxComponent:
			for group in detection_groups:
				if area.is_in_group(group):
					attack.attack_position = global_position
					hit.emit(area)
					area.damage(attack)
					break
