extends Resource
class_name Attack

@export var attack_damage := 0.0
@export var knockback_force := 0.0
@export var stun_time := 0.2

var attack_position := Vector3.ZERO


func _init(
		dam := attack_damage,
		knock := knockback_force,
		pos := attack_position,
		stun := stun_time,
		):
	attack_damage = dam
	knockback_force = knock
	attack_position = pos
	stun_time = stun
