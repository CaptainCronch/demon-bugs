extends InventoryRef
class_name WeightedInventoryRef

@export var weights : PackedInt32Array = []


func _init():
	if slotrefs.size() != weights.size(): # they should map 1 to 1
		push_error("Slotrefs and weights' sizes don't match!")


func get_random_slotref() -> SlotRef :
	var total_weight := 0
	for weight in weights:
		total_weight += weight
	var chosen_value := randi_range(0, total_weight)
	var i := 0
	for weight in weights:
		if chosen_value <= weight:
			print("returned an item")
			return slotrefs[i]
		else:
			chosen_value += weight
		i += 1
	print("returned null")
	return null
