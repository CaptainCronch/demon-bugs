extends BugState

@export var chase_speed := 3.5


func enter():
	plat_comp.move_speed = chase_speed
	detect_comp.active = true



func physics_update(_delta):
	if not detect_comp.active:
		transitioned.emit(self, "wait")
