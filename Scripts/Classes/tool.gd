extends Item
class_name Tool

signal used()

@export var projectile_scene : PackedScene
@export var attack : Attack
@export var attack_cooldown := 0.0
@export var cap_damage_amount := 0
@export var chargeable := false
@export var type := TYPE.NONE
@export var property := PROPERTY.NONE

@export var melee_comp : MeleeComponent

var charging := false
var charge_power := 0.0

enum TYPE {
	NONE,
	MELEE,
	RANGED,
	HARVEST,
}

enum PROPERTY {
	NONE,
	NATURAL,
	DEMONIC,
	METALLIC,
}


func _ready():
	super()
	mass = 2.0


func _process(delta):
	if charging: charge_power += delta


func on_use(player : Player, pos := Vector3(), rot := Vector3()) -> void : ## Call from inherited object only after using charge_power variable
	charging = false
	charge_power = 0.0

	attack.attack_position = pos
	if is_instance_valid(projectile_scene): shoot(projectile_scene)
	if is_instance_valid(melee_comp): melee_comp.melee(attack, pos, rot)
	if cap_damage_amount != 0: player.health_comp.cap_damage(cap_damage_amount)


func charge() -> void:
	charging = true


func shoot(projectile : PackedScene):
	var shot := projectile.instantiate()
	get_tree().current_scene.add_child(shot)
	shot.global_position = get_parent().get_parent().global_position
	shot.rotation = global_rotation
	shot.hurt_area_comp.attack = attack
