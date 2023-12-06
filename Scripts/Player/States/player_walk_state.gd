extends PlayerState

var walk_move_speed := 4.0


func enter():
	player.move_speed = walk_move_speed
	# play walk anim


func update(_delta):
	super.get_interact_input()
	if Input.is_action_pressed("run"):
		transitioned.emit(self, "playerrun")
	
	if player.move_dir.length_squared() <= 0:
		transitioned.emit(self, "playeridle")
