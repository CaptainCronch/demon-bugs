extends PlayerMoveState

@export var run_move_speed := 6.0

func enter():
	player.plat_comp.move_speed = run_move_speed
	# play run anim


func update(_delta):
	if not Input.is_action_pressed("run"):
		transitioned.emit(self, "walk")
	
	if player.plat_comp.move_dir.length_squared() <= 0:
		transitioned.emit(self, "idle")
