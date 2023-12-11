extends PlayerItemState


func update(_delta) -> void :
	if Input.is_action_just_pressed("interact"):
		pick_up()

	if not player.holding_item: return
	if Input.is_action_pressed("drop"):
		if player.item_holder.get_child(0) is Item:
			transitioned.emit(self, "throw")
	elif Input.is_action_just_pressed("use"):
		if player.item_holder.get_child(0) is Tool:
			transitioned.emit(self, "charge")


func pick_up():
	if not player.holding_item and player.pickup_area.has_overlapping_bodies():
		var body := player.pickup_area.get_overlapping_bodies()[0]
		if body is Item:
			body.get_parent().remove_child(body)
			player.item_holder.add_child(body)
			body.global_position = player.item_holder.global_position
			body.rotation = player.item_holder.rotation
			body.freeze = true
			player.holding_item = true
			player.held_item = player.item_holder.get_child(0)
		if body is Tool:
			player.hurt_area_comp.collider.shape.size.z = body.range + 1
			player.hurt_area_comp.collider.position.z = body.range / -2
