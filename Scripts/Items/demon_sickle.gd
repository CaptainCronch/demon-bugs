extends Tool

@export var projectile := preload("res://Scenes/Projectiles/demon_sickle_projectile.tscn")
@export var cap_damage_amount := 0


func on_use():
	var shot := projectile.instantiate()
	get_tree().current_scene.add_child(shot)
	shot.global_position = get_parent().get_parent().global_position
	shot.rotation = global_rotation
	shot.hurt_area_comp.attack = attack


func player_effect(player : Player) -> void :
	player.health_comp.cap_damage(cap_damage_amount)
