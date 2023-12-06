extends PlayerState

@export var hold_move_speed := 1.0


func enter():
	player.move_speed = hold_move_speed
	#player.animation_player.play("hold")


func update(_delta):
	if not Input.is_action_pressed("use"):
		transitioned.emit(self, "playeruse")
