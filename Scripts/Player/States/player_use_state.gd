extends PlayerItemState

@onready var cooldown_timer = $Cooldown


func enter():
	if player.held_item is Melee:
		player.animation_player.play("swing_down", -1, 1 / player.held_item.attack_cooldown)
	else:
		cooldown_timer.start(player.held_item.attack_cooldown)
	player.held_item.on_use()
	player.held_item.player_effect(player)


func update(_delta):
	if not player.animation_player.is_playing() and cooldown_timer.is_stopped():
		transitioned.emit(self, "hold")


func active_swing(on : bool) -> void :
	player.plat_comp.turning = !on
