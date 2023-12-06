extends PlayerState


func enter():
	pass
	# play idle anim


func update(_delta):
	super.get_interact_input()
	
	if player.move_dir.length_squared() <= 0: return
	
	if Input.is_action_pressed("run"):
		transitioned.emit(self, "playerrun")
	else:
		transitioned.emit(self, "playerwalk")
	# switch to random idle anims
