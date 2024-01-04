extends CharacterBody3D
class_name Player

var jump_move_multiplier := 1.2
var throw_force := 5.0
var buffer_time := 0.2
var coyote_time := 0.2

var holding_item := false
var held_item : Item

@export var idle_heal_bonus := 1.0

@export var inventory : InventoryRef
@export var armor_inventory : ArmorInventoryRef
@export var accessory_inventory : InventoryRef
@export var ui : UI

@export var model : VisualInstance3D
@export var item_holder : Node3D
@export var spring_arm : SpringArm3D
@export var buffer_timer : Timer
@export var coyote_timer : Timer
@export var animation_player : AnimationPlayer
@export var pickup_area : Area3D
@export var health_bar : TextureProgressBar
@export var cap_health_bar : TextureProgressBar

@export var plat_comp : PlatformerComponent
@export var health_comp : HealthComponent
@export var mod_comp : ModifierComponent


func _ready() -> void :
	ui.set_inventory_data(inventory, true, armor_inventory, accessory_inventory)
	ui.active_slot_changed.connect(switch_held)
	inventory.inventory_updated.connect(_on_inventory_updated)

	health_bar.max_value = health_comp.max_health
	health_bar.value = health_comp.health
	health_comp.health_changed.connect(update_health_bar)

	cap_health_bar.max_value = health_comp.max_health
	cap_health_bar.value = health_comp.max_health - health_comp.cap_health
	health_comp.cap_health_changed.connect(update_cap_health_bar)

	if item_holder.get_child_count() > 0:
		holding_item = true
		held_item = item_holder.get_child(0)
		held_item.global_position = item_holder.global_position
		for child in held_item.get_children():
				if child is CollisionShape3D:
					child.disabled = true


func _process(_delta : float) -> void :
	get_input()


func _physics_process(_delta : float) -> void :
	air_movement(_delta)
	pick_up()

	if is_zero_approx(velocity.x) and is_zero_approx(velocity.z):
		health_comp.heal_bonus.add_bonus("idle", idle_heal_bonus)
	else:
		health_comp.heal_bonus.remove_bonus("idle")


func _unhandled_input(event : InputEvent) -> void :
	if event.is_action_pressed("jump"):
		buffer_timer.start(buffer_time) # waits until you touch the ground to jump
	elif event.is_action_pressed("open_inventory"):
		ui.slide_inventory()


func get_input() -> void :
	plat_comp.move_dir = Vector2.ZERO

	plat_comp.move_dir.x = Input.get_axis("left", "right")
	plat_comp.move_dir.y = Input.get_axis("forward", "back")
	plat_comp.move_dir = plat_comp.move_dir.rotated(-spring_arm.rotation.y).limit_length()


func air_movement(_delta : float) -> void :
	if is_on_floor():
		coyote_timer.start(coyote_time) # starts letting you jump

	if not coyote_timer.is_stopped() and not buffer_timer.is_stopped():
		plat_comp.jump()
		plat_comp.move_multiplier = jump_move_multiplier
		velocity.x *= jump_move_multiplier
		velocity.z *= jump_move_multiplier

		buffer_timer.stop()
		coyote_timer.stop()

	#if not Input.is_action_pressed("jump"):
		#if plat_comp.explosive_jumping: return
		#if velocity.y > plat_comp.jump_force * 0.5 and velocity.y <= plat_comp.jump_force * 1:
			#velocity.y = plat_comp.jump_force * 0.5 # jump cut when you let go of jump
			#
			#plat_comp.move_multiplier = 1.0 # resets speed boost to discourage spamming
			#var cut_velocity := plat_comp.move_dir * plat_comp.move_speed
			#if Vector2(velocity.x, velocity.z).length_squared() > cut_velocity.length_squared():
				#velocity.x = cut_velocity.x # removes multiplier from move speed
				#velocity.z = cut_velocity.y


func throw_item(power_level) -> void :
	var item : Item = item_holder.get_child(0) as Item
	if not is_instance_valid(item): return

	for child in item.get_children():
		if child is CollisionShape3D:
			child.disabled = false

	item_holder.remove_child(item)
	get_tree().current_scene.add_child(item)

	item.global_position = item_holder.global_position
	item.rotation.y = model.rotation.y
	item.freeze = false
	holding_item = false
	held_item = null
	var offset := randf_range(-1.0, 1.0)
	item.linear_velocity = (Vector3(0, 0.5, -1).rotated(Vector3.UP, model.rotation.y) * throw_force * power_level) + (velocity * 0.5)
	item.angular_velocity = Vector3(offset, offset, offset) * throw_force

	inventory.delete_slotref(ui.active_slot)


func pick_up() -> void : # if item fits delete item else set item quantity to remainder
	if pickup_area.has_overlapping_bodies():
		for body in pickup_area.get_overlapping_bodies():
			if body is Item and body.grabbable:
				var result := inventory.add_slotref(body.slotref)
				if result == null: body.free()
				else: body.slotref = result


func switch_held(index : int):
	var slotref : SlotRef = inventory.get_slotref(index)
	#var new_item = item.item_scene.instantiate()
	if not is_instance_valid(slotref):
		if is_instance_valid(held_item): # if nothing in new slot but held item then delete item and return
			held_item.free()
		return

	if is_instance_valid(held_item): # if held item and new slot is actually new then delete held item
		if slotref != held_item.slotref: # but if the new slot is the same as held item then return
			held_item.free()
		else:
			return

	held_item = Global.tag_to_item(slotref.itemref.ref_id).instantiate()
	item_holder.add_child(held_item)

	held_item.global_position = item_holder.global_position
	held_item.rotation = item_holder.rotation
	held_item.freeze = true

	held_item.slotref = slotref
	holding_item = true

	for child in held_item.get_children():
		if child is CollisionShape3D:
			child.disabled = true


func _on_inventory_updated(new_invref: InventoryRef):
	if not is_instance_valid(held_item): # if not holding an item switch to current slot (does nothing if nothing in slot)
		switch_held(ui.active_slot)
		return
	elif not new_invref.get_slotref(ui.active_slot): # if no item in slot delete held item
		held_item.free()
		return
	elif new_invref.get_slotref(ui.active_slot) != held_item.slotref: # if item different then switch
		call_deferred("switch_held", ui.active_slot) #switch_held(ui.active_slot)
		return


func stun(time : float) -> void :
	plat_comp.stun(time)


func explode(origin : Vector3, radius : float, power : float, upthrust := 0.0) -> void :
	plat_comp.explode(origin, radius, power, upthrust)


func update_health_bar(_attack = null) -> void :
	health_bar.value = health_comp.health


func update_cap_health_bar(_amount = null) -> void :
	cap_health_bar.value = health_comp.max_health - health_comp.cap_health
	update_health_bar()


func _on_interact_body_entered(body):
	if body is Chest: ui.external_inventory.add_external_inventory(body)


func _on_interact_body_exited(body):
	if body is Chest: ui.external_inventory.remove_external_inventory(body)
