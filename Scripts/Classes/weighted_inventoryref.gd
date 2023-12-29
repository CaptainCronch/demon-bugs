extends Resource
class_name WeightedInventoryRef

@export var weighted_slotrefs : Array[WeightedSlotRef] = []


#func _init():
	#if get_slotrefs().size() != weights.size(): # they should map 1 to 1
		#push_error("Slotrefs and weights' sizes don't match!")


func get_slotrefs() -> Array[WeightedSlotRef] :
	return weighted_slotrefs


func get_slotref(index : int) -> WeightedSlotRef :
	return weighted_slotrefs[index]


func set_slotref(index : int, value : WeightedSlotRef) -> void :
	weighted_slotrefs[index] = value


func get_slotref_by_id(id : String) -> WeightedSlotRef :
	for slot in weighted_slotrefs:
		if slot.itemref.ref_id == id:
			return slot
	return null


func get_random_slotref() -> SlotRef : # returns weighted random slotref with random amount
	var total_weight := 0
	for slot in weighted_slotrefs:
		total_weight += slot.weight
	var chosen_value := randi_range(1, total_weight)
	#print(chosen_value, "/", total_weight)
	for slot in weighted_slotrefs:
		if chosen_value <= slot.weight:
			return slot.consolidate()
		else:
			chosen_value -= slot.weight
	print("fucking none")
	return null
