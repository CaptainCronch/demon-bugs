extends PlayerState

@export var run_move_speed := 6.0

func enter():
	player.move_speed = run_move_speed
	# play run anim


func update(_delta):
	super.get_interact_input()
	
	if not Input.is_action_pressed("run"):
		transitioned.emit(self, "playerwalk")
	
	if player.move_dir.length_squared() <= 0:
		transitioned.emit(self, "playeridle")
