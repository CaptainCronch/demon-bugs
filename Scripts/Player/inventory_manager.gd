extends Node
class_name InventoryManager

@export var inventory_panel : PanelContainer


func set_inventory_data(invref : InventoryRef) -> void:
	invref.inventory_interact.connect(_on_inventory_interact)
	inventory_panel.populate_grid(invref)


func _on_inventory_interact(invref : InventoryRef, index : int, button : int) -> void :
	print("yayyy")
