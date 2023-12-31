extends BugState

@export var wait_time := 3.0

@onready var wait_timer : Timer = $Wait


func enter():
	plat_comp.move_dir = Vector2.ZERO
	wait_timer.start(randfn(1, random_spread) * wait_time)
	detect_comp.interest_entered.connect(func(): transitioned.emit(state_machine.current_state, "chase"))


func update(_delta):
	if wait_timer.is_stopped():
		transitioned.emit(self, "wander")
