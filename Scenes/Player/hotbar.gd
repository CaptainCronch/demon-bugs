extends HBoxContainer

@export var inventory : InventoryManager
@export var item_display : PackedScene

var slots : Array[TextureRect] = []


func ready():
	print("HELPPPP")
	for slot in inventory.inventory_size:
		var new_display := item_display.instantiate()
		slots.append(new_display)
		add_child(new_display)
		new_display
