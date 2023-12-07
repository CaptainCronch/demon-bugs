extends PlayerMoveState

var walk_move_speed := 4.0


func enter():
	player.plat_comp.move_speed = walk_move_speed
	# play walk anim


func update(_delta):
	if Input.is_action_pressed("run"):
		transitioned.emit(self, "run")
	
	if player.plat_comp.move_dir.length_squared() <= 0:
		transitioned.emit(self, "idle")
