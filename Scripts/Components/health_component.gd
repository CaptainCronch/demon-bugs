extends Node
class_name HealthComponent

signal damage_taken(attack : Attack)
signal cap_damage_taken(amount : float)
signal healed(amount : float)
signal cap_healed(amount : float)
signal health_changed(amount : float)
signal cap_health_changed(amount : float)
signal death(attack : Attack)

@export var max_health : float
@export var target : Node3D
@export var invincibility_time := 0.0
@export var heal_amount := 0.0
@export var heal_time := 5.0
@export var heal_delay := 5.0
@export var cap_heal_amount := 5.0
@export var cap_heal_time := 0.25
@export var cap_heal_delay := 2.0

var cap_health := 0.0
var health := 0.0
var true_health := 0.0

@onready var invincibility_timer : Timer = $Invincibility
@onready var heal_timer : Timer = $Heal
@onready var cap_heal_timer : Timer = $CapHeal
@onready var heal_delay_timer = $HealDelay
@onready var cap_heal_delay_timer = $CapHealDelay


func _ready():
	cap_health = max_health
	health = max_health
	true_health = max_health
	heal_delay_timer.start(heal_delay)
	cap_heal_delay_timer.start(cap_heal_delay)

	cap_health_changed.connect(update_ratio)


func damage(attack : Attack):
	heal_delay_timer.start(heal_delay)
	heal_timer.stop()
	if attack.attack_damage <= 0: return
	if not invincibility_timer.is_stopped(): return
	health -= roundf(attack.attack_damage)
	damage_taken.emit(attack)
	if health <= 0:
		die(attack)
		return
	if is_zero_approx(invincibility_time): return
	invincibility_timer.start(invincibility_time)
	health_changed.emit(-attack.attack_damage)


func cap_damage(amount : float) -> void :
	cap_heal_delay_timer.start(cap_heal_delay)
	cap_heal_timer.stop()
	if amount <= 0: return
	var health_ratio := inverse_lerp(0, cap_health, health)
	cap_health = maxf(cap_health - amount, 1)
	var prev_health := health
	health = cap_health * health_ratio
	cap_damage_taken.emit(amount)
	cap_health_changed.emit(-amount)

	if prev_health - health > 0:
		health_changed.emit(prev_health - health * -1)


func die(attack):
	death.emit(attack)
	target.queue_free()


func heal(amount : float) -> void :
	if amount <= 0: return
	health = minf(health + heal_amount, cap_health)
	healed.emit(amount)
	health_changed.emit(amount)


func heal_cap(amount : float) -> void :
	if amount <= 0: return
	var health_ratio := inverse_lerp(0, cap_health, health)
	cap_health = minf(cap_health + amount, max_health)
	health = cap_health * health_ratio
	cap_healed.emit(amount)
	cap_health_changed.emit(amount)


func update_ratio(amount : float) -> void :
	true_health


func _on_heal_timeout():
	heal(heal_amount)
	heal_timer.start(heal_time)


func _on_cap_heal_timeout():
	heal_cap(cap_heal_amount)
	cap_heal_timer.start(cap_heal_time)
