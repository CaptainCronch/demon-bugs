extends CharacterBody3D

@onready var plat_comp : PlatformerComponent = $PlatformerComponent


func _process(delta):
	plat_comp.move_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	if randf() > 0.99 and is_on_floor():
		plat_comp.jump()


func flash_explosion():
	$ExplodeArea/ExplosionEffect.visible = true
	await get_tree().create_timer(0.1).timeout
	$ExplodeArea/ExplosionEffect.visible = false


func _on_timer_timeout():
	flash_explosion()
	
	for body in $ExplodeArea.get_overlapping_bodies():
		if body.has_method("explode") and body != self:
			body.explode(global_position, $ExplodeArea/CollisionShape3D.shape.radius, 15, 0)
