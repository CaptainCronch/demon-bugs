extends PlayerItemState


func update(_delta) -> void :
	if not player.holding_item: return
	if Input.is_action_pressed("drop"):
		if player.item_holder.get_child(0) is Item:
			transitioned.emit(self, "throw")
	elif Input.is_action_just_pressed("use"):
		if player.item_holder.get_child(0) is Tool:
			transitioned.emit(self, "charge")
