extends Node
class_name HealthComponent

signal damage_taken(attack : Attack)
signal death()

@export var max_health : int
@export var target : Node3D

@onready var health := max_health


func damage(attack : Attack):
	health -= roundi(attack.attack_damage)
	damage_taken.emit(attack)
	if health <= 0:
		die()


func die():
	death.emit()
	target.queue_free()
