extends BugState

@export var attack_speed := 8.0
@export var attack_duration := 0.5

@export var hurt_area_comp : HurtAreaComponent


func enter():
	#hurt_area_comp.monitoring = true
	plat_comp.move_speed = attack_speed
	detect_comp.active = false
	plat_comp.jump()
	plat_comp.instant_velocity(detect_comp.chosen_dir)
	await get_tree().create_timer(attack_duration).timeout
	#hurt_area_comp.monitoring = false
	transitioned.emit(self, "chase")
