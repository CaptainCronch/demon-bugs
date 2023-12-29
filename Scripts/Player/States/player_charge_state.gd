extends PlayerItemState

@export var slow_move_speed := 1.0



func enter() -> void :
	if not player.held_item.chargeable:
		transitioned.emit(self, "use")
	#player.plat_comp.move_speed = slow_move_speed
	#player.animation_player.play("hold")


func update(_delta) -> void :
	if not Input.is_action_pressed("use"):
		transitioned.emit(self, "use")
