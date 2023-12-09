extends Node3D

@export var target : Node3D


func _process(_delta):
	rotation.y = target.rotation.y
