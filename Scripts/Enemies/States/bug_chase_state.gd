extends BugState

@export var chase_speed := 3.0
@export var attack_distance := 5.0
@export var cooldown_time := 3.0
@export var health_comp : HealthComponent

var active := false

@onready var cooldown_timer : Timer = $AttackCooldown


func _ready():
	health_comp.damage_taken.connect(_on_damage_taken)


func enter():
	active = true
	plat_comp.move_speed = chase_speed
	detect_comp.active = true


func physics_update(_delta):
	if not detect_comp.active:
		transitioned.emit(self, "wait")
	elif cooldown_timer.is_stopped() and detect_comp.distance_to_target <= attack_distance and plat_comp.is_on_floor():
		cooldown_timer.start(randfn(cooldown_time, random_spread))
		transitioned.emit(self, "anticipation")


func exit():
	active = false


func _on_damage_taken(_attack) -> void :
	if not active: return
	cooldown_timer.start(randfn(cooldown_time, random_spread))
