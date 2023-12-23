extends CharacterBody3D
class_name Bug

@export var item_spawn_force := 12.0
@export var inventory : WeightedInventoryRef
@export var explode_attack : Attack
@export var plat_comp : PlatformerComponent
@export var health_comp : HealthComponent


func _ready():
	health_comp.death.connect(_on_death)


func _process(_delta):
	pass
	#plat_comp.move_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	#
	#if randf() > 0.99 and is_on_floor():
		#plat_comp.jump()


func _on_death(attack : Attack):
	Global.spawn_item_pop(inventory.get_random_slotref(), global_position, item_spawn_force, item_spawn_force, attack.attack_position.direction_to(global_position))


#func flash_explosion():
	#$ExplodeArea/ExplosionEffect.visible = true
	#await get_tree().create_timer(0.1).timeout
	#$ExplodeArea/ExplosionEffect.visible = false
#
#
#func _on_timer_timeout():
	#flash_explosion()
	#
	#for body in $ExplodeArea.get_overlapping_bodies():
		#if body.has_method("explode") and body != self:
			#body.explode(global_position, $ExplodeArea/CollisionShape3D.shape.radius, 15, 0)
	#
	#for area in $ExplodeArea.get_overlapping_areas():
		#if area is HitboxComponent and area != $HitboxComponent:
			#area.damage(explode_attack)
