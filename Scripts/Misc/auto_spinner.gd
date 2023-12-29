extends Node3D

@export var spin_speed := 12.0


func _process(delta):
	rotate_y(spin_speed * delta)
