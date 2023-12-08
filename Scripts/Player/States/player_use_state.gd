extends PlayerItemState


func enter():
	player.animation_player.play("swing_down", -1, player.held_item.attack_cooldown)


func update(_delta):
	if not player.animation_player.is_playing():
		transitioned.emit(self, "hold")


func active_swing(on : bool) -> void :
	player.held_item.on_use(on)
	player.plat_comp.turning = !on
