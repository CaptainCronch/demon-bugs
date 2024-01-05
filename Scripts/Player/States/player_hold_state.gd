extends PlayerItemState

@export var ui : UI

var active := false


func enter(): active = true


#func update(_delta) -> void :

	#elif Input.is_action_just_pressed("use"):
		#if player.item_holder.get_child(0) is Tool:
			#transitioned.emit(self, "charge")


func _unhandled_input(event):
	if not active: return
	if event.is_action_pressed("use"):
		if is_instance_valid(player.held_item) and player.held_item is Tool:
			transitioned.emit(self, "charge")
	#elif event.is_action_pressed("interact"):
		#player.pick_up()
	elif event.is_action_pressed("drop") and is_instance_valid(player.held_item):
		if is_instance_valid(player.held_item) and player.held_item is Item:
			transitioned.emit(self, "throw")
	elif event.is_action_pressed("next_hotbar_slot"):
		ui.change_active_slot(ui.active_slot + 1)
	elif event.is_action_pressed("previous_hotbar_slot"):
		ui.change_active_slot(ui.active_slot - 1)


func _unhandled_key_input(event):
	if not active or not event.is_pressed(): return
	if range(KEY_1, KEY_6).has(event.keycode):
		ui.change_active_slot(event.keycode - KEY_1)



func exit(): active = false
