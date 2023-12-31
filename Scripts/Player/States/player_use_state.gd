extends PlayerItemState

@onready var cooldown_timer = $Cooldown

var attacking := false


func enter():
	attacking = true


func physics_update(_delta) -> void : # Tool melee check must occur during physics frame
	if attacking:
		if player.held_item.type == Tool.TYPE.MELEE:
			player.animation_player.play("swing_down", -1, 1 / player.held_item.attack_cooldown)
		else:
			cooldown_timer.start(player.held_item.attack_cooldown)
		player.held_item.on_use(player.global_position, player.model.rotation)
		player.held_item.player_effect(player)

		attacking = false
	elif not player.animation_player.is_playing() and cooldown_timer.is_stopped():
		transitioned.emit(self, "hold")


func exit():
	attacking = false


func attacking_swing(on : bool) -> void :
	player.plat_comp.turning = !on
