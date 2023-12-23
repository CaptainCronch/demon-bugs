extends VBoxContainer

const INVENTORY_PANEL_SCENE := preload("res://Scenes/Player/UI/inventory_panel.tscn")

var chests : Array[Chest] = []

@onready var tab_bar : TabBar = $TabBar
@onready var ui = $".."


func add_external_inventory(chest: Chest):
	var inv := INVENTORY_PANEL_SCENE.instantiate()
	add_child(inv)
	move_child(inv, 0)
	inv.set_inventory_data(chest.inventory)
	chest.inventory.inventory_interact.connect(ui._on_inventory_interact)
	inv.parent_node = chest
	change_tab(0)
	tab_bar.add_tab("Chest")
	chests.append(chest)


func remove_external_inventory(chest: Chest):
	var i := 0
	for child in get_children():
		if child is InventoryPanel and child.parent_node == chest:
			chest.inventory.inventory_interact.disconnect(ui._on_inventory_interact)
			chests.erase(chest)
			child.free()
			tab_bar.remove_tab(i)
			change_tab(0)
			return
		i += 1


func change_tab(input : int):
	var tab := input if (input >= 0 and input < get_child_count() - 1) else 0
	for child in get_children():
		if child is TabBar: return
		if child.get_index() == tab:
			child.visible = true
		else:
			#print(child.get_index())
			child.visible = false


func _on_tab_clicked(tab):
	print("CLICKED")
	change_tab(tab)
