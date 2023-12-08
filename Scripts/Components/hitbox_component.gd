extends Area3D
class_name HitboxComponent

@export var health_comp : HealthComponent


func _ready():
	if not collision_layer and not collision_mask:
		printerr("HitboxComponent of ", get_parent().name, " has no collision bits enabled!")


func damage(attack : Attack):
	if health_comp: health_comp.damage(attack)
