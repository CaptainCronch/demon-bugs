extends PlayerMoveState


func enter():
	pass
	# play idle anim


func update(_delta):
	if player.plat_comp.move_dir.length_squared() <= 0: return

	if Input.is_action_pressed("run"):
		transitioned.emit(self, "run")
	else:
		transitioned.emit(self, "walk")
	# switch to random idle anims
