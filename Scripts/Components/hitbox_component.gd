extends Area3D
class_name HitboxComponent

@export var health_comp : HealthComponent
@export var spin_target : Node3D


func _ready():
	if not collision_layer and not collision_mask:
		printerr("HitboxComponent of ", get_parent().name, " has no collision bits enabled!")


func _process(_delta):
	if spin_target: rotation.y = spin_target.rotation.y


func damage(attack : Attack):
	if health_comp: health_comp.damage(attack)
