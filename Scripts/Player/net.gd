extends Tool

@export var net_area : Area3D


func on_use(on : bool) -> void :
	net_area.monitorable = on
	net_area.monitoring = on


func _on_area_entered(area):
	if area is HitboxComponent:
		attack.attack_position = global_position
		area.damage(attack)
