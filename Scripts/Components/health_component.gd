extends Node3D
class_name HealthComponent

signal damage_taken(attack : Attack)
signal cap_damage_taken(amount : float)
signal healed(amount : float)
signal cap_healed(amount : float)
signal health_changed(amount : float)
signal cap_health_changed(amount : float)
signal death(attack : Attack)

const number_popup := preload("res://Scenes/number_popup.tscn")

@export var default_color := Color.RED
@export var blocked_color := Color.DARK_ORANGE
@export var max_health : float
@export var target : Node3D
@export var invincibility_time := 0.0
@export var heal_min_rate := 0.0
@export var heal_max_rate := 0.0
@export var heal_time := 10.0
@export var heal_delay := 5.0
@export var cap_heal_min_rate := 1.0
@export var cap_heal_max_rate := 20.0
@export var cap_heal_time := 20.0
@export var cap_heal_delay := 2.0
@export var heal_tick := 0.25
@export var defense := 0.0

var cap_health := 0.0
var health := 0.0
var cap_heal_rate := 0.0
var heal_rate := 0.0
var heal_multiplier := 1.0
var cap_heal_multiplier := 1.0
var dead := false

var heal_bonus : BonusManager
var defense_bonus : BonusManager
var heal_tween : Tween
var cap_heal_tween : Tween

@onready var invincibility_timer : Timer = $Invincibility
@onready var heal_timer : Timer = $Heal
@onready var cap_heal_timer : Timer = $CapHeal
@onready var heal_delay_timer : Timer = $HealDelay
@onready var cap_heal_delay_timer : Timer = $CapHealDelay


func _ready():
	heal_bonus = BonusManager.new()
	defense_bonus = BonusManager.new()
	defense_bonus.multiplicative = false
	#heal_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	#cap_heal_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	cap_health = max_health
	health = max_health
	cap_heal_rate = cap_heal_max_rate
	heal_rate = heal_max_rate
	heal_delay_timer.start(heal_delay)
	cap_heal_delay_timer.start(cap_heal_delay)


func damage(attack : Attack):
	if dead: return
	heal_delay_timer.start(heal_delay)
	heal_timer.stop() # stop healing even if damage is 0
	heal_rate = heal_min_rate
	if heal_tween: heal_tween.kill()
	if attack.attack_damage <= 0: return
	if not invincibility_timer.is_stopped(): return
	print(defense + defense_bonus.get_total())
	var total_attack := attack.attack_damage - (defense + defense_bonus.get_total())
	if total_attack <= 0.0:
		spawn_number_popup("BLOCKED!!", blocked_color)
		return

	health -= roundf(total_attack)
	damage_taken.emit(attack)
	health_changed.emit(-attack.attack_damage)
	spawn_number_popup(str(roundf(total_attack)), default_color)

	if health <= 0:
		die(attack)
		return
	if is_zero_approx(invincibility_time): return
	invincibility_timer.start(invincibility_time)


func cap_damage(amount : float) -> void :
	if dead: return
	cap_heal_delay_timer.start(cap_heal_delay)
	cap_heal_timer.stop()
	cap_heal_rate = cap_heal_min_rate
	if cap_heal_tween: cap_heal_tween.kill()
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
	if dead: return
	death.emit(attack)
	dead = true
	target.queue_free()


func heal(amount : float) -> void :
	if dead: return
	if amount <= 0: return
	health = minf(health + amount, cap_health)
	healed.emit(amount)
	health_changed.emit(amount)


func heal_cap(amount : float) -> void :
	if dead: return
	if amount <= 0: return
	var health_ratio := inverse_lerp(0, cap_health, health)
	cap_health = minf(cap_health + amount, max_health)
	health = cap_health * health_ratio
	cap_healed.emit(amount)
	cap_health_changed.emit(amount)


func spawn_number_popup(value : String, color := Color.RED):
	if dead: return
	var new_popup := number_popup.instantiate()
	get_tree().current_scene.add_child(new_popup)
	new_popup.global_position = global_position
	new_popup.text = value
	new_popup.modulate = color


func _on_heal_timeout():
	heal(heal_rate * (cap_health / max_health) * heal_bonus.get_total())
	heal_timer.start(heal_tick)


func _on_cap_heal_timeout():
	heal_cap(cap_heal_rate * heal_bonus.get_total())
	cap_heal_timer.start(heal_tick)


func _on_heal_delay_timeout():
	_on_heal_timeout()
	if heal_tween:
		heal_tween.kill()
	heal_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	heal_tween.tween_property(self, "heal_rate", heal_max_rate, heal_time)


func _on_cap_heal_delay_timeout():
	_on_cap_heal_timeout()
	if cap_heal_tween:
		cap_heal_tween.kill()
	cap_heal_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	cap_heal_tween.tween_property(self, "cap_heal_rate", cap_heal_max_rate, cap_heal_time)

