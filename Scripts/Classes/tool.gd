extends Item
class_name Tool

@export var attack : Attack
@export var attack_cooldown := 0.2
@export var attack_range = 2.0
@export var chargeable := false

func on_use(_on : bool) -> void :
	pass
