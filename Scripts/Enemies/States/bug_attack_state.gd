extends BugState

@export var attack_speed := 8.0
@export var attack_duration := 0.5
@export var hurt_area_comp : HurtAreaComponent

@onready var attack_timer : Timer = $AttackTimer


func enter():
	#hurt_area_comp.monitoring = true
	plat_comp.move_speed = attack_speed
	detect_comp.active = false
	plat_comp.jump()
	plat_comp.instant_velocity(detect_comp.chosen_dir)
	attack_timer.start(attack_duration)


func physics_update(_delta):
	if not attack_timer.is_stopped(): return
	#hurt_area_comp.monitoring = false
	transitioned.emit(self, "chase")
