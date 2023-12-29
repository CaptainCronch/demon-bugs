extends Item
class_name Tool

@export var attack : Attack
@export var attack_cooldown := 0.2
@export var chargeable := false

var charging := false
var charge_power := 0.0


func _ready():
	super()
	mass = 2.0


func _process(delta):
	if charging: charge_power += delta


func on_use() -> void : ## Call from inherited object only after using charge_power variable
	charging = false
	charge_power = 0.0


func charge() -> void:
	charging = true


func player_effect(player : Player) -> void :
	pass
