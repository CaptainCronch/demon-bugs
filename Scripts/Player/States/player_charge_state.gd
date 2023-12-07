extends PlayerItemState

@export var slow_move_speed := 1.0

var power_level := 0


func enter() -> void :
	pass
	#player.plat_comp.move_speed = slow_move_speed
	#player.animation_player.play("hold")


func update(_delta) -> void :
	if not Input.is_action_pressed("use"):
		transitioned.emit(self, "use")
