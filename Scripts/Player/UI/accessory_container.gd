extends InventoryPanel

@export var allowed_tags : PackedStringArray


func populate_grid(invref: InventoryRef) -> void :
	for child in grid.get_children():
		child.queue_free()

	for slotref in invref.get_slotrefs():
		var item_display = SLOT.instantiate()
		grid.add_child(item_display)

		item_display.slot_clicked.connect(invref._on_slot_clicked)
		item_display.allowed_items.append_array(allowed_tags)

		if slotref:
			item_display.set_slotref(slotref)
