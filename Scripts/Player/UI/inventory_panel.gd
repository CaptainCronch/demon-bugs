extends PanelContainer

const SLOT := preload("res://Scenes/Player/UI/item_display.tscn")

@onready var grid = $MarginContainer/GridContainer


func set_inventory_data(invref : InventoryRef) -> void :
	invref.inventory_updated.connect(populate_grid)
	populate_grid(invref)


func populate_grid(invref: InventoryRef) -> void :
	for child in grid.get_children():
		child.queue_free()
	#print("populated grid")
	for slotref in invref.slotrefs:
		var item_display = SLOT.instantiate()
		grid.add_child(item_display)

		item_display.slot_clicked.connect(invref._on_slot_clicked)

		if slotref:
			item_display.set_slotref(slotref)
