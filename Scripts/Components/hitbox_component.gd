extends Area3D
class_name HitboxComponent

const number_popup := preload("res://Scenes/number_popup.tscn")

@export var color := Color.RED
@export var health_comp : HealthComponent
@export var spin_target : Node3D


func _ready():
	if not collision_layer and not collision_mask:
		printerr("HitboxComponent of ", get_parent().name, " has no collision bits enabled!")


func _process(_delta):
	if spin_target: rotation.y = spin_target.rotation.y


func damage(attack : Attack):
	if health_comp: health_comp.damage(attack)
	var new_popup := number_popup.instantiate()
	get_tree().current_scene.add_child(new_popup)
	new_popup.global_position = global_position
	new_popup.text = str(attack.attack_damage)
	new_popup.modulate = color
