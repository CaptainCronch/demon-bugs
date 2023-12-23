extends RigidBody3D
class_name Chest

#signal toggle_inventory(external_inventory_owner)

@export var inventory : InventoryRef


func player_interact() -> Chest :
	return self
