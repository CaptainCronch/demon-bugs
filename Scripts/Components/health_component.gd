extends Node
class_name HealthComponent

signal damage_taken(attack : Attack)
signal death(attack : Attack)

@export var max_health : int
@export var target : Node3D
@export var invincibility_time := 0.0

@onready var health := max_health
@onready var invincibility_timer : Timer = $Invincibility


func damage(attack : Attack):
	if not invincibility_timer.is_stopped(): return
	health -= roundi(attack.attack_damage)
	damage_taken.emit(attack)
	if health <= 0:
		die(attack)
		return
	if is_zero_approx(invincibility_time): return
	invincibility_timer.start(invincibility_time)



func die(attack):
	death.emit(attack)
	target.queue_free()
