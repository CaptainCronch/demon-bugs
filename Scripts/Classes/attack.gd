extends Resource
class_name Attack

@export var attack_damage := 0.0
@export var knockback_force := 0.0
@export var stun_time := 0.2

var attack_position := Vector3.ZERO


func init(
		dam := attack_damage,
		knock := knockback_force,
		pos := attack_position,
		stun := stun_time,
		) -> Attack :
	var attack := Attack.new()
	attack.attack_damage = dam
	attack.knockback_force = knock
	attack.attack_position = pos
	attack.stun_time = stun
	return attack
